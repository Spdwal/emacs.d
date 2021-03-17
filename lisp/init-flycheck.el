;;----------------------------------------------------------------------
;; 语法检查
;;----------------------------------------------------------------------
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  ;;; 除去 el 文件中的 header footer 语法检查
  :config (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))



(provide 'init-flycheck)
;;; init-flycheck.el ends here
