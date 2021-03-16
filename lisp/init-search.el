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
	ivy-re-builders-alist '((t . ivy--regex-ignore-order))))

(use-package counsel
  :after (ivy)
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
	 ;; 从 recentf-list 中寻找文件
         ("C-c f" . counsel-recentf)
	 ;; 从当前 git 仓库中寻找一个文件
         ("C-c g" . counsel-git)))

;; 搜索用的包
(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper-isearch-backward))
                ;; 如果不是 nil 则 swiper 搜索结束后，重新定位回屏幕中间
  :config (setq swiper-action-recenter t
		;; 搜索时显示行号
		swiper-include-line-number-in-search t))







(provide 'init-search)
