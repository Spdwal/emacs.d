 ;; 将mac的command键盘设置为meta
(when *is-a-mac*
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifire 'none))

;; 使用 y/n 代替 yes/no
(use-package emacs
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))

;; C-SPC 被系统占用，所以使用 Shift-SPC 代替
(global-set-key (kbd "S-SPC") 'set-mark-command)

;; hungry-delete 并绑定键位
;; C-c DEL 删除到前一个非空字符
;; C-c d   删除到后一个非空字符
(use-package hungry-delete
  :bind (("C-c DEL" . hungry-delete-backward))
  :bind (("C-c d" . hungry-delete-forward)))

;; 使用curx包
(use-package crux
  ;; 智能删除行
  :bind ("C-c k" . crux-smart-kill-line)
  ;; 智能添加一个空行，并且锁紧
  :bind ("M-o". crux-smart-open-line))

(use-package drag-stuff
  :bind (("<M-up>" . drag-stuff-up)
	 ("<M-down>" . drag-stuff-down)))

(provide 'init-kb-gobal)

