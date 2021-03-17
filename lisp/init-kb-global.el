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
  :bind (("C-c DEL" . hungry-delete-backward)
	 ("C-c d" . hungry-delete-forward)))

;; 使用curx包
(use-package crux
         ;; 智能删除行
  :bind (("C-c k" . crux-smart-kill-line)
	 ;; 智能添加一个空行，并且锁紧
	 ("M-o" . crux-smart-open-line)
	 ;; 跳到本行缩进后的第一个字符处
	 ("C-a" . crux-move-beginning-of-line)
	 ;; 智能将下面的空行删除
	 ("C-c ^" . crux-top-join-line)
	 ;; 自动跳到 init.el
	 ("C-x ." . crux-find-user-init-file)
	 ;; 自动复制黏贴当前行
	 ("C-S-d" . crux-duplicate-current-line-or-region)))

(use-package drag-stuff
  :bind (("<M-up>" . drag-stuff-up)
	 ("<M-down>" . drag-stuff-down)))

(use-package buffer-move
  :bind (("C-c <up>" . buf-move-up)
	 ("C-c <down>" . buf-move-down)
	 ("C-c <left>" . buf-move-left)
	 ("C-c <right>" . buf-move-right)))

(provide 'init-kb-global)

