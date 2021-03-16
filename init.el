;;----------------------------------------------------------------------
;; 一些初始化配置
;;----------------------------------------------------------------------

;; 添加自定义目录到 load-path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; 设置用户自定义文件
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; 检查emacs版本，并且报出错误信息
(let ((minver "25.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "26.1")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

;; 设置垃圾回收阈值为最大，可以加快启动速度
(setq gc-cons-threshold most-positive-fixnum)


;;----------------------------------------------------------------------
;; 判断操作系统，并做一些gobal键位绑定
;;----------------------------------------------------------------------
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))

(require 'init-start)

(require 'init-kb-gobal)
(require 'init-ui)


(require 'init-search)
