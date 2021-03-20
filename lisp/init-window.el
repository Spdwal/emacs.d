;;----------------------------------------------------------------------
;;  使用 switch-window
;;----------------------------------------------------------------------
(use-package switch-window
  :config
                ;; 使用字母来选择buffers
  (setq-default switch-window-shortcut-style 'alphabet
		switch-window-timeout nil)
  :bind
  (("C-x o" . switch-window)))
