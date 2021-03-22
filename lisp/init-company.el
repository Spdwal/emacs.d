
(use-package company
  :diminish (company-mode " Cmp.")
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  ;; 全局加载 company
  :hook (after-init . global-company-mode)
  ;; 绑定常用快捷键
  :bind (:map company-active-map
	      (("C-n" . company-select-next)
	       ("C-p" . company-select-previous)
	       ("C-d" . company-show-doc-buffer)
	       ("<tab>" . company-complete)
	       ("M-." . company-show-location)
	       ("M-/" . company-other-backend)))
  :config (setq company-dabbrev-code-everywhere t
		        company-dabbrev-code-modes t
		        company-dabbrev-code-other-buffers 'all
		        company-dabbrev-downcase nil
		        company-dabbrev-ignore-case t
		        company-dabbrev-other-buffers 'all
		        company-require-match nil
		        company-minimum-prefix-length 1
		        company-show-numbers t
		        company-tooltip-limit 20
		        company-idle-delay 0
		        company-echo-delay 0
		        company-tooltip-offset-display 'scrollbar
		        company-begin-commands '(self-insert-command))
  (eval-after-load 'company
    '(add-to-list 'company-backends
                  '(company-abbrev company-yasnippet company-capf))))

;; Better sorting and filtering
(use-package company-prescient
  :init (company-prescient-mode 1))



;; 括号自动补全
(electric-pair-mode 1)

(setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)


;; (defun add-electric-pairs ()
;;   (if (member major-mode '(emacs-lisp-mode))
;;       (setq-local electric-pair-pairs
;;       '(
;; 	(?\" . ?\")   ;; 添加双引号补齐
;; 	(?\{ . ?\})   ;; 添加大括号补齐
;; 	(?\' . ?\')   ;; 添加单引号补全
;; 	(?\’ . ?\‘))) ;; 添加中文单引号补全
;;     (setq-local electric-pair-pairs
;;       '(
;; 	(?\" . ?\")   ;; 添加双引号补齐
;; 	(?\{ . ?\})   ;; 添加大括号补齐
;; 	(?\’ . ?\‘))))) ;; 添加中文单引号补全

;; (add-hook 'prog-mode-hook 'add-electric-pairs)

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))


(provide 'init-company)
