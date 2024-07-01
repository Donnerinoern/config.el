(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(electric-pair-mode 1)
(global-hl-line-mode 1)
(global-auto-revert-mode 1)
(add-to-list 'default-frame-alist
            '(font . "Iosevka Medium-12"))

(setq use-short-answers t
      display-line-numbers-type 'relative
      dired-dwim-target t
      dired-auto-revert-buffer t
      dired-recursive-copies 'always
      dired-create-destination-dirs 'ask
      global-auto-revert-non-file-buffers t
      indent-tabs-mode t
      history-length 25
      use-dialog-box nil
      custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; chocolate-theme
(use-package chocolate-theme
  :config
  (load-theme 'chocolate t))

;; all-the-icons
(use-package all-the-icons
  :if (display-graphic-p))

;; all-the-icons-completion
(use-package all-the-icons-completion
  :config
  (all-the-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup))

;; evil
(use-package evil
  :init
  (setq evil-want-keybinding nil
	evil-want-integration t
	evil-want-C-i-jump nil
	evil-respect-visual-line-mode t
	evil-want-C-h-delete t
	evil-search-module 'evil-search
	evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>bn") 'evil-next-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>bp") 'evil-prev-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>bd") 'evil-delete-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>bb") 'consult-buffer)

  (evil-define-key 'normal 'global (kbd "<leader>ff") 'find-file)
  (evil-define-key 'normal 'global (kbd "<leader>fr") 'consult-recent-file)
  (evil-define-key 'normal 'global (kbd "<leader>fh") 'project-find-file)
  (evil-define-key 'normal 'globak (kbd "<leader>sp") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader>sf") 'consult-line)

  (evil-define-key 'normal 'global (kbd "<leader>de") 'consult-flymake)

  (evil-define-key 'normal 'global (kbd "<leader>gs") 'magit-stage-file)
  (evil-define-key 'normal 'global (kbd "<leader>gc") 'magit-commit)
  (evil-define-key 'normal 'global (kbd "<leader>gp") 'magit-push)
  (evil-define-key 'normal 'globak (kbd "<leader>gP") 'magit-pull)
  (evil-define-key 'normal 'global (kbd "<leader>gf") 'magit-fetch)

  (evil-define-key 'normal 'global (kbd "<leader>0") 'delete-window)
  (evil-define-key 'normal 'global (kbd "<leader>wh") 'windmove-left)
  (evil-define-key 'normal 'global (kbd "<leader>wj") 'windmove-down)
  (evil-define-key 'normal 'global (kbd "<leader>wk") 'windmove-up)
  (evil-define-key 'normal 'global (kbd "<leader>wl") 'windmove-right))

;; evil-collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; evil-multiedit
(use-package evil-multiedit
  :config
  (evil-multiedit-default-keybinds))

;; evil-org
(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; evil-snipe
(use-package evil-snipe
  :config
  (evil-snipe-mode)
  (add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode))

;; evil-commentary
(use-package evil-commentary
  :init
  (evil-commentary-mode))

;; which-key
(use-package which-key
  :init
  (which-key-mode))

;; corfu
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-preselect 'prompt)
  (corfu-history-mode 1)
  (setq completion-category-overrides '((eglot (styles orderless))
					(eglot-capf (styles orderless))))
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  :bind
  (:map corfu-map
	("TAB" . corfu-next)
	([tab] . corfu-next)
	("C-TAB" . corfu-previous)
	([backtab] . corfu-previous))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(add-to-list 'savehist-additional-variables 'corfu-history)

;; cape
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))

;; vertico
(use-package vertico
  :init
  (require 'vertico-directory)
  (customize-set-variable 'vertico-cycle t)
  (vertico-mode))

;; orderless
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrider '(file (styles partial-completion)))
  :bind (:map vertico-map
	     ("C-k" . vertico-previous)
	     ("C-j" . vertico-next)))

;; consult
(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
	register-preview-function #'consult-register-format
	xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref)
	;; completion-in-region-function #'consult-completion-in-region)
  (keymap-set minibuffer-local-map "C-r" 'consult-history))

(with-eval-after-load 'consult
;; hide full buffer list (still available with "b" prefix)
(consult-customize consult--source-buffer :hidden t :default nil)
;; set consult-workspace buffer list
(defvar consult--source-workspace
  (list :name     "Workspace Buffers"
        :narrow   ?w
        :history  'buffer-name-history
        :category 'buffer
        :state    #'consult--buffer-state
        :default  t
        :items    (lambda () (consult--buffer-query
                         :predicate #'tabspaces--local-buffer-p
                         :sort 'visibility
                         :as #'buffer-name)))

  "Set workspace buffer list for consult-buffer.")
(add-to-list 'consult-buffer-sources 'consult--source-workspace))

;; marginalia
(use-package marginalia
  :init
  (marginalia-mode))

;; embark
(use-package embark
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :bind
  (("C-'" . embark-act)
   ("C-;" . embark-dwim)
   ("C-h b" . embark-bindings))
  :config
  (add-to-list 'display-buffer-alist
	      '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
		nil
		(window-parameters (mode-line-format . none)))))

;; embark-consult
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; magit
(use-package magit)

;; hl-todo
(use-package hl-todo
  :config
  (global-hl-todo-mode))

;; highlight-indent-guides
(use-package highligh-indent-guides
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (setq highlight-indent-guides-method 'character))

;; ligature
(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  (global-ligature-mode t))
