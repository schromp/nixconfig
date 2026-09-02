(require 'package)

(defconst lk/backup-directory
  (expand-file-name "emacs/backups/"
                    (or (getenv "XDG_CACHE_HOME") "~/.cache/")))
(make-directory lk/backup-directory t)
(setq backup-directory-alist `(("." . ,lk/backup-directory)))

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

(defun lk/prepend-exec-path (directory)
  "Make executables in DIRECTORY available to GUI Emacs."
  (let ((expanded-directory (expand-file-name directory)))
    (when (file-directory-p expanded-directory)
      (add-to-list 'exec-path expanded-directory)
      (setenv "PATH" (mapconcat #'identity exec-path path-separator)))))

;; macOS applications do not inherit the shell's Nix profile environment.
(lk/prepend-exec-path "/run/current-system/sw/bin")
(lk/prepend-exec-path "~/.nix-profile/bin")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

;; Avoid frequent garbage-collection pauses during interactive use.
(setq gc-cons-threshold (* 64 1024 1024))

(defconst lk/default-font-family "MonaspiceAr Nerd Font Mono")
(defconst lk/symbol-font-family "Iosevka Nerd Font Mono")
(defconst lk/default-font-height 160)
(set-face-attribute 'default nil
                    :family lk/default-font-family
                    :height lk/default-font-height)
(set-face-attribute 'fixed-pitch nil
                    :family lk/default-font-family
                    :height lk/default-font-height)
(add-to-list 'default-frame-alist
             `(font . ,(format "%s-%d"
                               lk/default-font-family
                               (/ lk/default-font-height 10))))

(defun lk/setup-symbol-font (&optional frame)
  (with-selected-frame (or frame (selected-frame))
    (when (display-graphic-p)
      (set-fontset-font t #x1f788
                        (font-spec :family lk/symbol-font-family)
                        nil 'prepend))))

(lk/setup-symbol-font)
(add-hook 'after-make-frame-functions #'lk/setup-symbol-font)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(setq-default indent-tabs-mode nil
              tab-width 2)

(defun lk/insert-soft-tab ()
  "Insert one indentation unit without reindenting the line."
  (interactive)
  (if indent-tabs-mode
      (insert "\t")
    (insert (make-string (max 1 (or (and (boundp 'evil-shift-width)
                                         evil-shift-width)
                                    tab-width
                                    2))
                         ?\s))))

(setq display-line-numbers-type t)
(global-display-line-numbers-mode 1)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-undo-system 'undo-redo
        evil-shift-width 2)
  :config
  (evil-mode 1)
  (evil-define-key 'insert 'global (kbd "TAB") #'lk/insert-soft-tab)
  (evil-define-key 'insert 'global (kbd "<tab>") #'lk/insert-soft-tab)
  (evil-define-key 'normal 'global
    (kbd "H") #'tab-bar-switch-to-prev-tab
    (kbd "L") #'tab-bar-switch-to-next-tab
    (kbd "SPC t n") #'tab-bar-new-tab
    (kbd "SPC t c") #'tab-bar-close-tab
    (kbd "SPC t r") #'tab-bar-rename-tab
    (kbd "SPC t t") #'tab-bar-switch-to-tab))

(use-package tab-bar
  :ensure nil
  :init
  (setq tab-bar-show 1)
  (tab-bar-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package vertico
  :init
  (vertico-mode 1)
  :bind
  (:map vertico-map
        ("C-j" . vertico-next)
        ("C-k" . vertico-previous)))

(use-package vertico-buffer
  :ensure nil
  :after vertico
  :custom
  (vertico-buffer-display-action
   '(display-buffer-at-bottom
     (window-height . 0.35))))

(use-package vertico-multiform
  :ensure nil
  :after (vertico vertico-buffer)
  :custom
  (vertico-multiform-commands
   '((consult-buffer buffer)
     (consult-fd buffer)
     (consult-ripgrep buffer)
     (consult-line buffer)
     (projectile-find-file buffer)
     (projectile-find-file-in-known-projects buffer)
     (projectile-switch-project buffer)))
  :config
  (vertico-multiform-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package projectile
  :after evil
  :init
  (setq projectile-project-search-path '(("~/repos" . 1)))
  :config
  (projectile-mode 1)
  (evil-define-key 'normal 'global (kbd "SPC p p") #'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "SPC p f") #'projectile-find-file)
  (evil-define-key 'normal 'global (kbd "SPC p F") #'projectile-find-file-in-known-projects))

(use-package dired
  :ensure nil
  :custom
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-listing-switches
   "-l --almost-all --human-readable --group-directories-first --no-group")
  :config
  (evil-define-key 'normal dired-mode-map
    (kbd "h") #'dired-up-directory
    (kbd "l") #'dired-find-file))

(use-package nerd-icons)

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  (evil-define-key 'normal 'global (kbd "SPC f d") #'dirvish-dwim)
  (evil-define-key 'normal 'global (kbd "SPC f D") #'dirvish)
  :custom
  (dirvish-attributes
   '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size))
  (dirvish-cache-dir
   (expand-file-name "emacs/dirvish/"
                     (or (getenv "XDG_CACHE_HOME") "~/.cache/")))
  (dirvish-large-directory-threshold 20000)
  (dirvish-preview-dispatchers '(pdf))
  (dirvish-quick-access-entries
   '(("h" "~/" "Home")
     ("r" "~/Repos/" "Repositories")
     ("d" "~/Downloads/" "Downloads")))
  :config
  (evil-define-key 'normal dirvish-mode-map
    (kbd "h") #'dired-up-directory
    (kbd "l") #'dired-find-file
    (kbd "?") #'dirvish-dispatch
    (kbd "a") #'dirvish-setup-menu
    (kbd "o") #'dirvish-quick-access
    (kbd "q") #'dirvish-quit
    (kbd "s") #'dirvish-quicksort
    (kbd "TAB") #'dirvish-subtree-toggle))

(use-package consult
  :after evil
  :config
  (evil-define-key 'normal 'global (kbd "SPC f c") #'consult-theme)
  (evil-define-key 'normal 'global (kbd "SPC f b") #'consult-buffer)
  (evil-define-key 'normal 'global (kbd "SPC f f") #'consult-fd)
  (evil-define-key 'normal 'global (kbd "SPC s g") #'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "SPC s l") #'consult-line))

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :init
  (global-corfu-mode 1)
  :config
  (corfu-popupinfo-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-preselect 'prompt)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  :bind
  (:map corfu-map
        ("<tab>" . corfu-complete)
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        ("C-y" . corfu-insert)))

(use-package editorconfig
  :ensure nil
  :init
  (editorconfig-mode 1))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package yaml-mode
  :demand t
  :custom
  (yaml-indent-offset 2)
  :config
  (define-derived-mode kubernetes-yaml-mode yaml-mode "Kubernetes YAML"
    "Major mode for Kubernetes manifests.")

  (define-derived-mode helm-template-mode yaml-mode "Helm"
    "Major mode for Helm chart YAML and templates.")

  (defun lk/kubernetes-yaml-buffer-p ()
    (and (save-excursion
           (goto-char (point-min))
           (re-search-forward "^apiVersion:[[:space:]]*[^[:space:]]" nil t))
         (save-excursion
           (goto-char (point-min))
           (re-search-forward "^kind:[[:space:]]*[^[:space:]]" nil t))))

  (defun lk/yaml-dispatch-mode ()
    (cond
     ((and buffer-file-name
           (locate-dominating-file
            (file-name-directory buffer-file-name) "Chart.yaml"))
      (helm-template-mode))
     ((or (and buffer-file-name
               (member (file-name-nondirectory buffer-file-name)
                       '("kustomization.yaml" "kustomization.yml")))
          (lk/kubernetes-yaml-buffer-p))
      (kubernetes-yaml-mode))
     (t
      (yaml-mode))))

  (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . lk/yaml-dispatch-mode)))

(use-package go-template-helper-mode
  :ensure nil
  :hook (helm-template-mode . go-template-helper-mode))

(use-package markdown-mode
  :commands (markdown-mode gfm-view-mode))

(use-package eldoc-box
  :commands eldoc-box-help-at-point
  :init
  (setq eldoc-display-functions '(eldoc-display-in-buffer))
  :custom
  (eldoc-box-clear-with-C-g t))

(defun lk/eglot-workspace-configuration (server)
  "Return workspace settings for SERVER's managed major mode."
  (cond
   ((memq 'helm-template-mode (eglot--major-modes server))
    '(:helm-ls (:yamlls (:path "yaml-language-server"))))
   ((memq 'kubernetes-yaml-mode (eglot--major-modes server))
    '(:yaml (:schemas (:kubernetes ["**/*.yaml" "**/*.yml"])
             :schemaStore (:enable t)
             :kubernetesCRDStore (:enable t))))
   (t
    '(:yaml (:schemaStore (:enable t))))))

(use-package eglot
  :ensure nil
  :hook ((nix-mode . eglot-ensure)
         (yaml-mode . eglot-ensure)
         (kubernetes-yaml-mode . eglot-ensure)
         (helm-template-mode . eglot-ensure))
  :config
  (setq-default eglot-workspace-configuration
                #'lk/eglot-workspace-configuration)
  (add-to-list 'eglot-server-programs
               '((kubernetes-yaml-mode :language-id "yaml")
                 . ("yaml-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((helm-template-mode :language-id "helm")
                 . ("helm_ls" "serve")))
  (evil-define-key 'normal eglot-mode-map (kbd "K") #'eldoc-box-help-at-point)
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

(defun lk/ghostel-new ()
  "Create and display a fresh Ghostel terminal."
  (interactive)
  (ghostel '(4)))

(defvar lk/ghostel-next-number 0
  "Last number assigned to a Ghostel terminal in this Emacs session.")

(defvar-local lk/ghostel-number nil
  "Stable number assigned to the current Ghostel terminal.")
(put 'lk/ghostel-number 'permanent-local t)

(defun lk/ghostel-setup-buffer ()
  "Give the current Ghostel buffer a stable numbered name."
  (display-line-numbers-mode -1)
  (unless lk/ghostel-number
    (setq lk/ghostel-next-number (1+ lk/ghostel-next-number)
          lk/ghostel-number lk/ghostel-next-number))
  (rename-buffer (format "*terminal-%d*" lk/ghostel-number) t))

(defun lk/ghostel-setup-existing-buffers ()
  "Assign stable numbered names to existing Ghostel buffers."
  (dolist (buffer (reverse (buffer-list)))
    (with-current-buffer buffer
      (when (derived-mode-p 'ghostel-mode)
        (lk/ghostel-setup-buffer)))))

(defun lk/ghostel-annotate-buffer (name)
  "Show terminal title and directory beside Ghostel buffer NAME."
  (when-let ((buffer (get-buffer name)))
    (with-current-buffer buffer
      (let* ((title (and (boundp 'ghostel--title) ghostel--title))
             (trimmed-title
              (and title
                   (if ghostel-annotation-title-width
                       (truncate-string-to-width
                        title ghostel-annotation-title-width nil nil t)
                     title)))
             (directory
              (abbreviate-file-name
               (directory-file-name default-directory))))
        (propertize
         (if trimmed-title
             (format "  %s  %s" trimmed-title directory)
           (format "  %s" directory))
         'face 'completions-annotations)))))

(use-package ghostel
  :ensure nil
  :commands (ghostel ghostel-project ghostel-list-buffers)
  :hook (ghostel-mode . lk/ghostel-setup-buffer)
  :custom
  (ghostel-buffer-name-function nil)
  (ghostel-buffer-identification-format "%b  %.30t  %.30d")
  :init
  (evil-define-key 'normal 'global
    (kbd "SPC o t") #'ghostel
    (kbd "SPC o T") #'lk/ghostel-new
    (kbd "SPC f t") #'ghostel-list-buffers)
  :config
  (advice-remove 'ghostel-annotate-buffer #'lk/ghostel-annotate-buffer)
  (advice-add 'ghostel-annotate-buffer :override #'lk/ghostel-annotate-buffer)
  (lk/ghostel-setup-existing-buffers)
  (set-face-attribute 'ghostel-default nil
                      :family lk/default-font-family
                      :height lk/default-font-height))

(use-package evil-ghostel
  :ensure nil
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult corfu doom-themes eldoc-box embark embark-consult
             evil-collection evil-ghostel go-template-helper-mode
             hotfuzz magit marginalia markdown-mode nix-mode orderless
             projectile vertico vterm yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
