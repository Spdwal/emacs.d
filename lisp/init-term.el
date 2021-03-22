(use-package eterm-256color
  :hook (
	 (term-mode . eterm-256color-mode)
	 (term-mode . (lambda ()
		       (display-line-numbers-mode 0)))))
    
;; 为 zsh 提供窗口模式
(defun ns/my-term-p (name _action)
  "Determine whether NAME names a `term-mode' buffer."
  (with-current-buffer name
    (derived-mode-p #'term-mode)))

;; 直接打开 zsh
(defun zsh ()
  (interactive)
  (let ((switch-to-buffer-obey-display-actions t))
    (ansi-term "zsh")))

(add-to-list 'display-buffer-alist '(ns/my-term-p () (inhibit-same-window . t)))

;; 设置 zsh 快捷键
(global-set-key (kbd "C-c t") 'zsh)

(provide 'init-term)



