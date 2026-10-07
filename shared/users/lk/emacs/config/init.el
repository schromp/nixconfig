(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(setq ring-bell-function #'ignore
    visible-bell nil)
(setq gc-cons-threshold (* 64 1024 1024))
(pixel-scroll-precision-mode 1)

(when (eq system-type 'darwin)
  (dolist (path (list (expand-file-name "~/.nix-profile/bin")
                      "/run/current-system/sw/bin"
                      "/opt/homebrew/bin"))
    (when (file-directory-p path)
      (add-to-list 'exec-path path)
      (setenv "PATH" (concat path ":" (getenv "PATH"))))))

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        ;; evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-undo-system 'undo-redo
        evil-shift-width 2)
  :config
  (evil-mode 1)
  (evil-define-key 'normal 'global
    (kbd "H") #'tab-bar-switch-to-prev-tab
    (kbd "L") #'tab-bar-switch-to-next-tab
    (kbd "SPC t n") #'tab-bar-new-tab
    (kbd "SPC t c") #'tab-bar-close-tab
    (kbd "SPC t r") #'tab-bar-rename-tab
    (kbd "SPC t t") #'tab-bar-switch-to-tab))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-define-key
  '("j" . meow-next)
  '("k" . meow-prev)
  '("<escape>" . ignore))
  (meow-leader-define-key
  ;; Use SPC (0-9) for digit arguments.
  '("1" . meow-digit-argument)
  '("2" . meow-digit-argument)
  '("3" . meow-digit-argument)
  '("4" . meow-digit-argument)
  '("5" . meow-digit-argument)
  '("6" . meow-digit-argument)
  '("7" . meow-digit-argument)
  '("8" . meow-digit-argument)
  '("9" . meow-digit-argument)
  '("0" . meow-digit-argument)
  '("/" . meow-keypad-describe-key)
  '("?" . meow-cheatsheet))
  (meow-normal-define-key
  '("0" . meow-expand-0)
  '("9" . meow-expand-9)
  '("8" . meow-expand-8)
  '("7" . meow-expand-7)
  '("6" . meow-expand-6)
  '("5" . meow-expand-5)
  '("4" . meow-expand-4)
  '("3" . meow-expand-3)
  '("2" . meow-expand-2)
  '("1" . meow-expand-1)
  '("-" . negative-argument)
  '(";" . meow-reverse)
  '("," . meow-inner-of-thing)
  '("." . meow-bounds-of-thing)
  '("[" . meow-beginning-of-thing)
  '("]" . meow-end-of-thing)
  '("a" . meow-append)
  '("A" . meow-open-below)
  '("b" . meow-back-word)
  '("B" . meow-back-symbol)
  '("c" . meow-change)
  '("d" . meow-delete)
  '("D" . meow-backward-delete)
  '("e" . meow-next-word)
  '("E" . meow-next-symbol)
  '("f" . meow-find)
  '("g" . meow-cancel-selection)
  '("G" . meow-grab)
  '("h" . meow-left)
  '("H" . meow-left-expand)
  '("i" . meow-insert)
  '("I" . meow-open-above)
  '("j" . meow-next)
  '("J" . meow-next-expand)
  '("k" . meow-prev)
  '("K" . meow-prev-expand)
  '("l" . meow-right)
  '("L" . meow-right-expand)
  '("m" . meow-join)
  '("n" . meow-search)
  '("o" . meow-block)
  '("O" . meow-to-block)
  '("p" . meow-yank)
  '("q" . meow-quit)
  '("Q" . meow-goto-line)
  '("r" . meow-replace)
  '("R" . meow-swap-grab)
  '("s" . meow-kill)
  '("t" . meow-till)
  '("u" . meow-undo)
  '("U" . meow-undo-in-selection)
  '("v" . meow-visit)
  '("w" . meow-mark-word)
  '("W" . meow-mark-symbol)
  '("x" . meow-line)
  '("X" . meow-goto-line)
  '("y" . meow-save)
  '("Y" . meow-sync-grab)
  '("z" . meow-pop-selection)
  '("'" . repeat)
  '("<escape>" . ignore)))

(use-package meow
    :ensure t)

;; (meow-setup)
  
;; (meow-global-mode 1)

(use-package spacious-padding
  :ensure t
  :config
  (spacious-padding-mode 1))

(defun my/setup-fonts ()
  "Configure fonts for GUI frames."
  (when (display-graphic-p)
    ;; 1. Global default (Monospace for code and general UI)
    (set-face-attribute 'default nil
                        :family "JetBrainsMono Nerd Font Mono"
                        :height 130
                        :weight 'regular)

    ;; 2. Explicit fixed-pitch (Inherited by mixed-pitch for tables, blocks, tags)
    (set-face-attribute 'fixed-pitch nil
                        :family "JetBrainsMono Nerd Font Mono"
                        :height 130
                        :weight 'regular)

    ;; 3. Variable-pitch (Used for prose and writing)
    (set-face-attribute 'variable-pitch nil
                        :family "Inter"
                        :height 140
                        :weight 'regular)

    ;; Fallback for glyphs not in JetBrainsMono Nerd Font (e.g. geometric shapes, emoji)
    (set-fontset-font t '(#x1f780 . #x1f7ff) "Iosevka Nerd Font Mono")
    (set-fontset-font t nil "Iosevka Nerd Font Mono" nil 'append)
    (set-fontset-font t nil "Apple Color Emoji" nil 'append)))

;; Apply fonts immediately if running as a standalone GUI app,
;; or defer until a GUI client connects to the daemon.
(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my/setup-fonts)
  (add-hook 'window-setup-hook #'my/setup-fonts))

(use-package mixed-pitch
  :ensure t
  :hook (org-mode . mixed-pitch-mode)
  :config
  ;; Ensure all technical Org elements remain strictly monospace
  (dolist (face '(org-table
                  org-block
                  org-block-begin-line
                  org-block-end-line
                  org-code
                  org-verbatim
                  org-checkbox
                  org-tag
                  org-formula
                  org-special-keyword
                  org-property-value))
    (add-to-list 'mixed-pitch-fixed-pitch-faces face)))

(use-package nerd-icons)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-tokyo-night t)
  (doom-themes-org-config))

(use-package vertico
  :init
  (vertico-mode 1)
  :bind
  (:map vertico-map
        ("C-j" . vertico-next)
        ("C-k" . vertico-previous)))

(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
  '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package savehist
  :init
  (savehist-mode))

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

(use-package consult
  :after evil
  :config
  (evil-define-key 'normal 'global (kbd "SPC f c") #'consult-theme)
  (evil-define-key 'normal 'global (kbd "SPC f b") #'consult-buffer)
  (evil-define-key 'normal 'global (kbd "SPC f f") #'consult-fd)
  (evil-define-key 'normal 'global (kbd "SPC s g") #'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "SPC s l") #'consult-line)
  :bind (("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)))

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package marginalia
  :init
  (marginalia-mode 1))

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
  (corfu-preview-current nil)
  :bind
  (:map corfu-map
        ("<tab>" . corfu-complete)
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        ("C-y" . corfu-insert)))

(use-package projectile
  :init
  (setq projectile-project-search-path '(("~/repos" . 1)))
  :bind-keymap
    ("C-x p" . projectile-command-map)
  :config
  (projectile-mode 1))

(use-package tab-bar
  :ensure nil
  :init
  (setq tab-bar-show 1)
  (tab-bar-mode 1))

(use-package org
  :ensure nil
  :hook
  (org-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  (require 'ox-latex)
  (require 'oc-biblatex)

  (add-to-list 'org-latex-classes
               '("thesis" "\\documentclass{scrreprt}"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

  (defun lk/org-export-latex-body ()
    "Export the current org buffer to a body-only .tex file beside it."
    (interactive)
    (org-export-to-file 'latex
        (concat (file-name-sans-extension buffer-file-name) ".tex")
      nil nil nil t))

  (defun lk/org-paper-dir-p ()
    "Return non-nil if the current file belongs to the thesis project."
    (and buffer-file-name
         (file-exists-p
          (expand-file-name "00-thesis-base.tex"
                            (file-name-directory buffer-file-name)))))

  (defun lk/org-paper-compile ()
    "Run latexmk on the thesis master file."
    (interactive)
    (let ((default-directory (file-name-directory buffer-file-name)))
      (compile "latexmk 00-thesis-base.tex")))

  (defun lk/org-paper-view ()
    "Open the compiled thesis PDF."
    (interactive)
    (find-file (expand-file-name "00-thesis-base.pdf"
                                 (file-name-directory buffer-file-name))))

  (defun lk/org-paper-setup ()
    (when (lk/org-paper-dir-p)
      (evil-define-key 'normal org-mode-map
        (kbd "SPC c c") #'lk/org-paper-compile
        (kbd "SPC c v") #'lk/org-paper-view)
      (add-hook 'after-save-hook #'lk/org-export-latex-body nil t)))

  (add-hook 'org-mode-hook #'lk/org-paper-setup))

(use-package olivetti
  :ensure t
  :hook (org-mode . olivetti-mode)     ; Center the text in Org mode
  :hook (org-mode . visual-line-mode)  ; Turn on soft word-wrapping
  :custom
  ;; Set the width of the central column. 
  ;; You can use an integer for character count (e.g., 80) 
  ;; or a float for a percentage of the window (e.g., 0.6)
  (olivetti-body-width 85))

(use-package ghostel
  :ensure t
  ;;:custom
  ;; Name buffers after the shell's OSC 2 title (current dir / running program)
  ;;(ghostel-buffer-name-function #'ghostel-buffer-name-by-title) ;
  :bind (("C-x t" . ghostel)))

(use-package evil-ghostel
  :ensure t
  :after (ghostel evil)
  :hook ((ghostel-mode . evil-ghostel-mode)))
         ;;(ghostel-mode . lk/ghostel-fix-evil-tab)))

;; (use-package consult-ghostel
;;   :hook (after-init . consult-ghostel-mode)
;;   :bind (("C-x m" . consult-ghostel)
;;         :map project-prefix-map
;;         ("m" . consult-ghostel-project)
;;         :map ghostel-semi-char-mode-map
;;         ("C-c h" . consult-ghostel-history)))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package just-mode
  :mode ("/[Jj]ustfile\\'" "\\.just\\'"))

(use-package go-mode
  :mode "\\.go\\'")

(use-package go-template-helper-mode
  :ensure nil
  :hook (helm-template-mode . go-template-helper-mode))

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

(use-package markdown-mode
  :commands (markdown-mode gfm-view-mode))

(use-package eglot
  :ensure t
  :hook ((nix-mode . eglot-ensure)
         (yaml-mode . eglot-ensure)
         (kubernetes-yaml-mode . eglot-ensure)
         (helm-template-mode . eglot-ensure)
         (LaTeX-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (go-ts-mode . eglot-ensure)
         (go-mod-ts-mode . eglot-ensure))
  :config
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
(with-eval-after-load 'evil
  ;; Unbind C-y in insert mode so Corfu (and native Emacs yank) can use it
  (define-key evil-insert-state-map (kbd "C-y") nil))

(use-package gptel
  :ensure t
  :config
  (setq gptel-backend
        (gptel-make-openai "Hypercharm"
          :host "hyper.charm.land"
          :protocol "https"
          :endpoint "/v1/chat/completions"
          :stream t
          :key "sk-hyper-141c7987-0ece-4e27-91cf-ab71680236da"
          :models '("gemma-4-26b-a4b-it")))
  (setq gptel-display-buffer-action
    '(nil (side . right) (window-width . 0.4)))
  (setq gptel-model "gemma-4-26b-a4b-it"))

(use-package agent-shell
  :ensure t
  :config
    (evil-define-key 'insert agent-shell-mode-map (kbd "RET") #'newline)
    (evil-define-key 'normal agent-shell-mode-map (kbd "RET") #'comint-send-input)

    (add-hook 'diff-mode-hook
              (lambda ()
                (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
                  (evil-emacs-state)))))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(setq-default indent-tabs-mode nil
              tab-width 2)

(setq display-line-numbers-type t)
(global-display-line-numbers-mode 1)

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

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  (evil-define-key 'normal 'global (kbd "SPC f d") #'dirvish-dwim)
  (evil-define-key 'normal 'global (kbd "SPC f D") #'dirvish)
  :custom
  (dirvish-attributes
   '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size))
  (dirvish-cache-dir
   (expand-file-name "emacs/dirvsh/"
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


(use-package editorconfig
  :ensure nil
  :init
  (editorconfig-mode 1))


(use-package pdf-tools
  :ensure nil
  :magic ("%PDF" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda () (display-line-numbers-mode -1)))
  :config
  (pdf-tools-install :no-query))

(use-package tex
  :ensure nil
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  (TeX-command-default "LatexMk")
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  (TeX-source-correlate-method 'synctex)
  :hook
  (LaTeX-mode . TeX-source-correlate-mode)
  :config
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)
  (evil-define-key 'normal LaTeX-mode-map
    (kbd "SPC c c") #'TeX-command-master
    (kbd "SPC c v") #'TeX-view))


(use-package eldoc-box
  :commands eldoc-box-help-at-point
  :init
  (setq eldoc-display-functions '(eldoc-display-in-buffer))
  :custom
  (eldoc-box-clear-with-C-g t))

(defun lk/setup-tree-sitter-grammars ()
  "Point Tree-sitter at the grammars shipped with the wrapped Emacs.
Nix puts them in the `emacs-packages-deps' lib directory, which is not
searched by default, and `go-ts-mode' only claims `.go' files when the
grammar is already available at load time."
  (when-let* ((deps-bin (seq-find (lambda (dir)
                                    (string-match-p "emacs-packages-deps/bin/\\'"
                                                    (file-name-as-directory dir)))
                                  exec-path))
              (grammar-dir (expand-file-name "../lib/"
                                             (directory-file-name deps-bin)))
              ((file-directory-p grammar-dir)))
    (add-to-list 'treesit-extra-load-path (file-name-as-directory grammar-dir))))

(lk/setup-tree-sitter-grammars)



(use-package magit
  :defer t
  :init
  (evil-define-key 'normal 'global (kbd "SPC g g") #'magit-status))

(defconst lk/leader-map (make-sparse-keymap)
  "SPC leader keys, taking precedence over mode-specific keymaps.")

(evil-make-intercept-map lk/leader-map 'normal)

;; Reuse the SPC prefix tree already bound in the global evil normal
;; state map, so leader keys also work in special buffers whose
;; mode-specific keymaps (e.g. pdf-view) shadow single keys like "f".
(with-eval-after-load 'evil
  (let ((spc (lookup-key evil-normal-state-map (kbd "SPC"))))
    (when (keymapp spc)
      (define-key lk/leader-map (kbd "SPC") spc))))
