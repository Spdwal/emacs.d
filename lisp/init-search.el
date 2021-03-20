(use-package ivy
  :defer 1
  :demand
  :hook (after-init . ivy-mode)
  :config
  (ivy-mode 1)
        ;; 把最近的文件和书签添加到 ivy-switch-buffer 中
  (setq ivy-use-virtual-buffers t
	;; 没整明白，好像和ivy-read有关，在init时候会调用这个列表里的所有命令
	ivy-initial-inputs-alist nil
	;; 在 M-x 寻找命令时候 最左边会出现 "index / count "
	ivy-count-format "%d / %d "
	;; 表示在使用 minibuffer 时候，可以使用适用于 minibuffer 的命令
	enable-recursive-minibuffers t
	;; 指定搜索时候调用的正则表达式函数
	ivy-re-builders-alist '((t . ivy--regex-ignore-order)
				;; ivy--regex-plus 支持模糊搜索，关键字之间用空格分割
				(swiper . ivy--regex-plus)
				(counsel-rg . ivy--regex-plus)
				(swiper-search . ivy--regex-plus))))

(use-package counsel
  :after (ivy)
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
	 ;; 从 recentf-list 中寻找文件
         ("C-c f" . counsel-recentf)
	 ;; 从当前 git 仓库中寻找一个文件
         ("C-c g" . counsel-git)
	 ("C-x b" . counsel-switch-buffer)))

;; 搜索用的包
(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper-isearch-backward))
                ;; 如果不是 nil 则 swiper 搜索结束后，重新定位回屏幕中间
  :config (setq swiper-action-recenter t
		;; 搜索时显示行号
		swiper-include-line-number-in-search t))
		
;;----------------------------------------------------------------------
;;  添加 ivy-posframe 包
;;  可以将一些需要使用minibuffer的命令框架移动到指定位置
;;----------------------------------------------------------------------
(use-package ivy-posframe
  :ensure t
  :diminish ivy-posframe-mode
  :custom-face
  (ivy-posframe ((t (:background "#333244"))))
  (ivy-posframe-border ((t (:background "#abff00"))))
  (ivy-posframe-cursor ((t (:background "#00ff00"))))
  :hook
  (ivy-mode . ivy-posframe-mode)
  :config
  ;; custom define height of post frame per function
  (setq ivy-posframe-height-alist '((swiper . 15)
                                    (find-file . 20)
                                    (counsel-ag . 15)
                                    (counsel-projectile-ag . 30)
                                    (t      . 25)))

  ;; display at `ivy-posframe-style'
  (setq ivy-posframe-display-functions-alist
        '((swiper          . ivy-posframe-display-at-window-center)
          (complete-symbol . ivy-posframe-display-at-point)
          ;;(counsel-M-x     . ivy-posframe-display-at-window-bottom-left)
          (counsel-M-x     . ivy-posframe-display-at-frame-center)
          (t               . ivy-posframe-display-at-frame-center)))
  (ivy-posframe-mode 1))

;;----------------------------------------------------------------------
;;  在minibuff里显示文件和buffer所在的文件夹
;;----------------------------------------------------------------------
(use-package ivy-rich
  :after counsel
  :init
  (setq ivy-rich-path-style 'abbrev
	ivy-virtual-abbreviate 'abbrevate)
  (setq ivy-rich-display-transformers-list
	'(counsel-switch-buffer
	  (:columns
	   ((ivy-rich-candidate (:width 30))
	    (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
	   :predicate
	   (lambda (cand) (get-buffer cand))))))

(provide 'init-search)
