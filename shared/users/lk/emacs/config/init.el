(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless)

(use-package hotfuzz
  :init
  (setq completion-styles '(hotfuzz orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion hotfuzz orderless basic)))))

(use-package projectile
  :after evil
  :init
  (setq projectile-project-search-path '(("~/repos" . 1)))
  :config
  (projectile-mode 1)
  (evil-define-key 'normal 'global (kbd "SPC p p") #'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "SPC p f") #'projectile-find-file)
  (evil-define-key 'normal 'global (kbd "SPC p F") #'projectile-find-file-in-known-projects))

(use-package consult
  :after evil
  :config
  (evil-define-key 'normal 'global (kbd "SPC f t") #'consult-theme)
  (evil-define-key 'normal 'global (kbd "SPC f b") #'consult-buffer))

(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :bind
  (:map corfu-map
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        ("C-y" . corfu-insert)))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package eglot
  :ensure nil
  :hook (nix-mode . eglot-ensure)
  :config
  (evil-define-key 'normal eglot-mode-map (kbd "K") #'eldoc-doc-buffer)
  (evil-define-key 'normal eglot-mode-map (kbd "] d") #'flymake-goto-next-error)
  (evil-define-key 'normal eglot-mode-map (kbd "[ d") #'flymake-goto-prev-error)
  (evil-define-key 'normal eglot-mode-map (kbd "SPC c d") #'flymake-show-buffer-diagnostics))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-tokyo-night t)
  (doom-themes-org-config))

(use-package magit
  :defer t
  :init
  (evil-define-key 'normal 'global (kbd "SPC g g") #'magit-status))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult corfu doom-themes evil-collection hotfuzz magit nix-mode
	     orderless projectile vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
