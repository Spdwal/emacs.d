
;; 更换主题为 spacemacs-theme 主题
(use-package spacemacs-theme
  :init (load-theme 'spacemacs-dark t))

;; 显示电量
(use-package fancy-battery
  :init
  (setq fancy-battery-show-percentage t)
  (fancy-battery-mode))

;;---------------------------------------------------------------------
;;  spaceline速度上有问题 
;;---------------------------------------------------------------------
(require 'spaceline-config)
(use-package spaceline
  ;; 启用 space-highlight-face-evil-state 别问我是干啥的，貌似是和evil有关，具体没查到
  ;; (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  :config
  ;; 启用spaceline
  (spaceline-spacemacs-theme)
  ;; 关闭spaceline-toggle-minor-mode
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-flycheck-error-on)
  (spaceline-toggle-flycheck-warning-on)
  (spaceline-toggle-version-control-on)
  (spaceline-toggle-line-column-on)
  (spaceline-toggle-battery-on)
  (spaceline-toggle-input-method-on))

(use-package nyan-mode
  :init
  (setq nyan-animate-nyancat t)
  (setq nyan-wavy-trail t)
  (setq nyan-minimum-window-width 80)
  (setq nyan-bar-length 20)
  (nyan-mode))


;; relative 相对行号
(use-package emacs
  :config
  (setq display-line-numbers-type 'relative)
  (global-display-line-numbers-mode))

(use-package fontawesome)

(provide 'init-ui)
