;;----------------------------------------------------------------------
;;  
;;----------------------------------------------------------------------
(use-package lsp-mode
  ;; 延迟加载，例如只有打开python文件时，才打开pyls
  :commands (lsp lsp-deferred)
         ;; 整合 which-key 插件, 
  :hook ((lsp-mode . lsp-enable-which-key-integration)
	 ;; 如果当前 major-mode 不是继承自lsp-mode或者elisp-mode,则启动lsp
	 (prog-mode . (lambda ()
			(unless (derived-mode-p 'emacs-lisp-mode 'lsp-mode)
			  (lsp-deferred)))))
              ;; 当最后一个 workspace buffer 关闭的时候，关闭 workspace
  :init (setq lsp-keep-workspace-alive nil
	      ;; 使用lsp的缩进
	      lsp-enable-indentation t
	      ;; 自动猜测根目录
	      lsp-auto-guess-root t
	      ;; 打开代码片段补全
	      lsp-enable-snippet t
	      ;; lsp flycheck
	      lsp-prefer-flymake t
	      ;; completion backend provider 不知道怎么翻译了，
	      ;; 使用了它，可以不使用 company-lsp
	      lsp-prefer-capf t
	      ;; 在 modeline 中显示代码中有多少错误
	      lsp-modeline-diagnostics-enable t
	      ;; 在manual上没查到，大概感觉上是一个workspace就是一个project
	      ;; 这里表示是在整个project中查找错误
	      ;; 存疑
	      lsp-modeline-diagnostics-scope :workspace
	      ;; 当 text 改变后0.5秒出发lsp补全
	      lsp-idle-delay 0.500
	      ;; 一次性最多可以从子进程中获取多少bytes的数据
	      read-process-output-max (* 1024 1024)
	      lsp-completion-provider :capf)
  :config
  ;; lsp-clents 保存了一个hash表，对应所有这册过的 lsp-server
  (use-package lsp-clients
    :ensure nil
    ;; 指定格式化document函数为 lsp-organize-imports
    ;; 履行 source.organizeImports 
    :functions (lsp-format-buffer lsp-organize-imports)))


;;; Optionally: lsp-ui, company-lsp
(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :hook ((lsp-mode . lsp-ui-mode)
	 ;; 在modeline上显示code actions
	 ;; 不知道具体什么是 code actions
         (lsp-ui-mode . lsp-modeline-code-actions-mode))
              ;; 显示 document
  :init (setq lsp-ui-doc-enable t
	      ;; 不使用 webkit
              lsp-ui-doc-use-webkit nil
	      ;; 0.3秒后显示 document
              lsp-ui-doc-delay .3
	      ;; 显示 签名
              lsp-ui-doc-include-signature t
	      ;; 指定显示 document 的位置
              lsp-ui-doc-position 'at-point ;; top/bottom/at-point
	      ;; 在 minibuffer 里显示 eldoc
              lsp-eldoc-enable-hover t
	      ;;----------------------------------------------------------------------
	      ;; 关闭 sideline, sideline 显示当页的信息
	      ;;----------------------------------------------------------------------
              lsp-ui-sideline-enable nil
              lsp-ui-sideline-show-hover nil
              lsp-ui-sideline-show-code-actions t
              lsp-ui-sideline-show-diagnostics t
	      ;; 忽略重复项
              lsp-ui-sideline-ignore-duplicate t
	      ;; modeline icons设置
              lsp-modeline-code-actions-segments '(count name)
	      ;; 关闭面包屑
              lsp-headerline-breadcrumb-enable nil)
  :config
  ;; 关闭 flyckeck
  (setq lsp-ui-flycheck-enable nil)
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (when (display-graphic-p)
    (treemacs-resize-icons 14)))


(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list
  :init
  (when (display-graphic-p)
    (treemacs-resize-icons 14)))


;;----------------------------------------------------------------------
;;  debug 用
;;----------------------------------------------------------------------
(use-package dap-mode
  :diminish
  :hook ((lsp-mode . dap-mode)
         (dap-mode . dap-ui-mode)
	     (dap-mode . dap-tooltip-mode)
         (python-mode . (lambda() (require 'dap-python)))))
         

(provide 'init-lsp)
