;; 关闭菜单栏
(tool-bar-mode -1)

;; 关闭右边滚动条
(scroll-bar-mode -1)

;; 关闭启动界面
(setq inhibit-startup-screen t)

;; 使用国内源
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")))

;; 关闭检查签名
(setq package-check-signature nil)

;; 引入package包
(require 'package)

;; 如果package没有初始化，则初始化它
(unless (bound-and-true-p package--intialized)
  (package-initialize))

;; package-archive-contents是一个表，包含了所有包在archives中的元信息
;; 如果为nill，则刷新contents
;; 这个值被保存在package.el中，并不是emacs自带
;; 必须要require过package，才能加载它。
(unless package-archive-contents
  (package-refresh-contents))

;; 如果没有安装use-package则刷新contents，安装它
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;;       永远加载
(setq use-package-always-ensure t
      ;; 永远延迟加载
      use-package-always-defer t
      ;; demant选项永远为 t
      use-package-always-demant nil
      ;; 关闭use-package的error check
      use-package-expand-minimally t
      ;; 打印加载package的log在 *Message* buffer里面
      use-package-verbose t)

;; 引入 use-package
(require 'use-package)

;; 引入restart-emacs 之后运行 restart-emacs命令可以重启emacs
(use-package restart-emacs)
(use-package benchmark-init
  :init (benchmark-init/activate)
  :hook (after-init . benchmark-init/deactivate))



(provide 'init-start)
