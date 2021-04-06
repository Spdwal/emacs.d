;; from https://github.com/purcell/emacs.d/blob/master/lisp/init-lisp.el

;; 当离开 debugger buffer 时， 关闭 debugger buffer
(setq-default debugger-bury-or-kill 'kill)

;; 包含 M-. M-, 两个快捷键
;; M-. 查找elisp定义用, 并将当前点push进 xref-maker-stack
;; M-, xref-pop-marker-stack 将之前的点pop出来，并且回到之前的点。
(use-package elisp-slime-nav
  :hook ((emacs-lisp-mode . turn-on-elisp-slime-nav-mode)
	 ;; inferior-emacs-lisp-mode-hook
	 ;; 此 mode 包含一些 lisp 快捷键
	 (ielm-mode . turn-on-elisp-slime-nav-mode)))

;;----------------------------------------------------------------------
;; 将eval-last-sexp 和eval-region 绑在同一个键位上
;;----------------------------------------------------------------------
(defun sanityinc/eval-last-sexp-or-region (prefix)
  "Eval region from BEG to END if active, otherwise the last sexp."
  (interactive "P")
  ;; use-region-p return p if the region is active
  (if (and (mark) (use-region-p))
      (eval-region (min (point) (mark)) (max (point) (mark)))
    (pp-eval-last-sexp prefix)))

(global-set-key [remap eval-expression] 'pp-eval-expression)

(with-eval-after-load 'lisp-mode
  (define-key emacs-lisp-mode-map (kbd "C-x C-e") 'sanityinc/eval-last-sexp-or-region)
  (define-key emacs-lisp-mode-map (kbd "C-c C-e") 'pp-eval-expression))


;;----------------------------------------------------------------------
;; 如果是.el.gz结尾的文件，则将 buffer 设置为只读
;;----------------------------------------------------------------------
(defun sanityinc/maybe-set-bundled-elisp-readonly ()
  "If this elisp appears to be part of Emacs, then disallow editing."
  (when (and (buffer-file-name)
             (string-match-p "\\.el\\.gz\\'" (buffer-file-name)))
    (setq buffer-read-only t)
    (view-mode 1)))


;; Use C-c C-z to toggle between elisp files and an ielm session
;; I might generalise this to ruby etc., or even just adopt the repl-toggle package.

(defvar-local sanityinc/repl-original-buffer nil
  "Buffer from which we jumped to this REPL.")

(defvar sanityinc/repl-switch-function 'switch-to-buffer-other-window)

(defun sanityinc/switch-to-ielm ()
  (interactive)
  (let ((orig-buffer (current-buffer)))
    ;; 如果存在 "ielm" buffer，则切换过去，否则直接启动 ielm
    (if (get-buffer "*ielm*")
        (funcall sanityinc/repl-switch-function "*ielm*")
      (ielm))
    ;; 保存当前buffer名字
    (setq sanityinc/repl-original-buffer orig-buffer)))

;; 切换回之前的 buffer
(defun sanityinc/repl-switch-back ()
  "Switch back to the buffer from which we reached this REPL."
  (interactive)
  (if sanityinc/repl-original-buffer
      (funcall sanityinc/repl-switch-function sanityinc/repl-original-buffer)
    (error "No original buffer")))

;; 按照模式，绑定按键，
(with-eval-after-load 'elisp-mode
  (define-key emacs-lisp-mode-map (kbd "C-c C-z") 'sanityinc/switch-to-ielm))
(with-eval-after-load 'ielm
  (define-key ielm-map (kbd "C-c C-z") 'sanityinc/repl-switch-back))

(add-hook 'emacs-lisp-mode-hook 'sanityinc/maybe-set-bundled-elisp-readonly)


;; ----------------------------------------------------------------------------
;; Hippie-expand
;; ----------------------------------------------------------------------------
;; 给 hippie-expand 设定函数列表
(defun set-up-hippie-expand-for-elisp ()
  "Locally set `hippie-expand' completion functions for use with Emacs Lisp."
  (make-local-variable 'hippie-expand-try-functions-list)
  ;; 尝试把一个单词作为 emacs lisp symbol 来补全
  (add-to-list 'hippie-expand-try-functions-list 'try-complete-lisp-symbol t)
  ;; 部分补全 emacs lisp symbol
  (add-to-list 'hippie-expand-try-functions-list 'try-complete-lisp-symbol-partially t))

;; ----------------------------------------------------------------------------
;; Automatic byte compilation
;; ----------------------------------------------------------------------------
;; 自动编译软件，防止emacs 调用过时的elc
(use-package auto-compile
  :hook ((after-init . auto-compile-on-save-mode)
	 (atter-init . auto-compile-on-load-mode))
  :config (setq auto-compile-delete-stry-dest nil))

;; ----------------------------------------------------------------------------
;; Load .el if newer than corresponding .elc
;; ----------------------------------------------------------------------------
(setq load-prefer-newer t)

(use-package immortal-scratch
  :hook (after-init . immortal-scratch-mode))



;;; Support byte-compilation in a sub-process, as
;;; required by highlight-cl

(defun sanityinc/byte-compile-file-batch (filename)
  "Byte-compile FILENAME in batch mode, ie. a clean sub-process."
  (interactive "fFile to byte-compile in batch mode: ")
  (let ((emacs (car command-line-args)))
    (compile
     ;; 合成一个命令，来编译文件
     (concat
      emacs " "
      (mapconcat
       'shell-quote-argument
       (list "-Q" "-batch" "-f" "batch-byte-compile" filename)
       " ")))))


;; ----------------------------------------------------------------------------
;; Enable desired features for all lisp modes
;; ----------------------------------------------------------------------------
;; check-parens 找到不匹配的括号, 并且抛出一个错误
(defun sanityinc/enable-check-parens-on-save ()
  "Run `check-parens' when the current buffer is saved."
  (add-hook 'after-save-hook #'check-parens nil t))

(defvar sanityinc/lispy-modes-hook
  '(enable-paredit-mode
    sanityinc/enable-check-parens-on-save)
  "Hook run in all Lisp modes.")


(use-package aggressive-indent
  :config
  (add-to-list 'sanityinc/lispy-modes-hook 'aggressive-indent-mode))

(defun sanityinc/lisp-setup ()
  "Enable features useful in any Lisp mode."
  (run-hooks 'sanityinc/lispy-modes-hook))

(defun sanityinc/emacs-lisp-setup ()
  "Enable features useful when working with elisp."
  (set-up-hippie-expand-for-elisp))

(defconst sanityinc/elispy-modes
  '(emacs-lisp-mode ielm-mode)
  "Major modes relating to elisp.")

(defconst sanityinc/lispy-modes
  (append sanityinc/elispy-modes
          '(lisp-mode inferior-lisp-mode lisp-interaction-mode))
  "All lispy major modes.")

;; 引入 derived 包
(require 'derived)

;; 为每一个mode产生一个hook，并且将其与lisp-setup相关联
(dolist (hook (mapcar #'derived-mode-hook-name sanityinc/lispy-modes))
  (add-hook hook 'sanityinc/lisp-setup))

(dolist (hook (mapcar #'derived-mode-hook-name sanityinc/elispy-modes))
  (add-hook hook 'sanityinc/emacs-lisp-setup))

;; 当 eval-expression-minibuffer-setup-hook存在的时候， hook中添加eldoc-mode
(when (boundp 'eval-expression-minibuffer-setup-hook)
  (add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode))

(add-to-list 'auto-mode-alist '("\\.emacs-project\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("archive-contents\\'" . emacs-lisp-mode))

(use-package cl-lib-highlight)
(with-eval-after-load 'lisp-mode
  (cl-lib-highlight-initialize))

;; ----------------------------------------------------------------------------
;; Delete .elc files when reverting the .el from VC or magit
;; ----------------------------------------------------------------------------

;; When .el files are open, we can intercept when they are modified
;; by VC or magit in order to remove .elc files that are likely to
;; be out of sync.

;; This is handy while actively working on elisp files, though
;; obviously it doesn't ensure that unopened files will also have
;; their .elc counterparts removed - VC hooks would be necessary for
;; that.

(defvar sanityinc/vc-reverting nil
  "Whether or not VC or Magit is currently reverting buffers.")

(defun sanityinc/maybe-remove-elc (&rest _)
  "If reverting from VC, delete any .elc file that will now be out of sync."
  (when sanityinc/vc-reverting
    (when (and (eq 'emacs-lisp-mode major-mode)
               buffer-file-name
               (string= "el" (file-name-extension buffer-file-name)))
      (let ((elc (concat buffer-file-name "c")))
        (when (file-exists-p elc)
          (message "Removing out-of-sync elc file %s" (file-name-nondirectory elc))
          (delete-file elc))))))
(advice-add 'revert-buffer :after 'sanityinc/maybe-remove-elc)

(defun sanityinc/reverting (orig &rest args)
  (let ((sanityinc/vc-reverting t))
    (apply orig args)))
(advice-add 'magit-revert-buffers :around 'sanityinc/reverting)
(advice-add 'vc-revert-buffer-internal :around 'sanityinc/reverting)


(use-package macrostep)

;; 补全macro
(with-eval-after-load 'lisp-mode
  (define-key emacs-lisp-mode-map (kbd "C-c x") 'macrostep-expand))


;; A quick way to jump to the definition of a function given its key binding
(global-set-key (kbd "C-h K") 'find-function-on-key)


;; Extras for theme editing

(defun sanityinc/enable-rainbow-mode-if-theme ()
  (when (and (buffer-file-name) (string-match-p "\\(color-theme-\\|-theme\\.el\\)" (buffer-file-name)))
    (rainbow-mode)))

(use-package rainbow-mode
  :hook ((emacs-lisp-mode . sanityinc/enable-rainbow-mode-if-theme)
	  (help-mode . rainbow-mode)))
  

;; (use-package highlight-quoted
;;   :hook (emacs-lisp-mode highlight-quoted-mode))

(use-package flycheck-package
  :config
  (with-eval-after-load 'flycheck
  (with-eval-after-load 'elisp-mode
      (flycheck-package-setup))))

;; ERT
(with-eval-after-load 'ert
  (define-key ert-results-mode-map (kbd "g") 'ert-results-rerun-all-tests))


(use-package cl-libify)

(use-package flycheck-relint)

(use-package cask-mode)

(provide 'init-elisp)
