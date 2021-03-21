(use-package eterm-256color
  :hook (
	 (term-mode . eterm-256color-mode)
	 (term-mode . (lambda ()
		       (display-line-numbers-mode 0))))
  :bind
  ("C-c t" . ansi-term))

(provide 'init-term)



