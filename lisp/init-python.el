(defvar python--tools '("python-language-server[all]"
                        "black"
                        "isort")
  "Modules for Python development")

(setq-default python-indent-offset 4
              python-indent-guess-indent-offset-verbose nil)

;; Use black to format the Python code
(use-package blacken
  :hook ((python-mode . blacken-mode)))

;; Sort the pytho imports
(use-package py-isort
  :init (setq python-sort-imports-on-save t))


(provide 'init-python)
