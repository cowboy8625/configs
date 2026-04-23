(add-to-list 'load-path  "~/.config/emacs/scripts/")
(require 'elpaca-setup)

(setq backup-directory-alist '(~/.local/share/Trash/files))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-message t)                 ;; Disable the welcome screen
(delete-selection-mode 1)                        ;; You can select text and delte it by typing.
(electric-indent-mode -1)                        ;; Turn off the weird indenting that Emacs does by default.
(electric-pair-mode -1)                          ;; Turn off automatic parens pairing
;; The following prevents <> from auto-pairing when electric-pair-mode is on.
;; Otherwise, org-tempo is broken when you try to <s TAB...
(add-hook 'org-mode-hook (lambda ()
	    (setq-local electric-pair-inhibit-predicate
		    `(lambda (c)
		(if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))
(global-auto-revert-mode t)                      ;; Automatically show changes if the file has changed
(global-display-line-numbers-mode 1)             ;; Display line numbers
(setq display-line-numbers 'relative)            ;; Display relative line numbers
(global-visual-line-mode t)                      ;; Enable truncated lines
(setq scroll-step 1 scroll-conservatively 10000) ;; Smooth scrolling
(setq org-edit-src-content-indentation 0)        ;; Set src block automatic indent to 0 instead of 2.
(setq ring-bell-function 'ignore)                ;; Turn off the annoying ringing when a key press is not valid
(global-hl-line-mode 1)
(custom-set-faces
 '(hl-line ((t (:background "#1a1d21")))))
;; TODO: Figure out how to highlight vertically
(add-to-list 'default-frame-alist '(alpha-background . 100)) ; For all new frames henceforth

(use-package evil
    :ensure t
    :init
    (setq evil-want-integration t
	evil-want-keybinding nil
	evil-vsplit-window-right t
	evil-vsplit-window-below t
	evil-undo-system 'undo-redo)
    :config
    (define-key evil-normal-state-map (kbd "-") #'dired-jump)
    (evil-mode 1))

(use-package evil-collection
    :after evil
    :ensure t
    :config
    (evil-collection-init))

(use-package doom-modeline
    :ensure t
    :init (doom-modeline-mode 1)
     :config
     (setq doom-modeline-height 35      ;; sets modeline height
 	  doom-modeline-bar-width 5    ;; sets right bar width
 	  doom-modeline-persp-name t   ;; adds perspective name to modeline
 	  doom-modeline-persp-icon t)) ;; adds folder icon next to persp name

(use-package toc-org
    :ensure t
    :commands toc-org-enable
    :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(eval-after-load 'org-indent '(diminish 'org-indent-mode))

(use-package doom-themes
    :config
    (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
    (load-theme 'doom-one t)
    (doom-themes-org-config))

(use-package general
    :config
    (general-evil-setup)

    (general-define-key
	:states '(normal visual insert emacs)
	:keymaps 'override
	"C-n" '(neotree-toggle :wk "Toggle neotree file viewer")
    )

    (general-create-definer cw/leader-keys
    :states '(normal visual insert emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC")  ;; access leader in insert mode

    (cw/leader-keys
    "r"  '(:ignore t :wk "Reloading Config")
    "r c" '((lambda () (interactive)
		    (load-file "~/.config/emacs/init.el")
		    (ignore (elpaca-process-queues))) :wk "Reload buffer"))

    (cw/leader-keys
    "f"   '(:ignore t :wk "Config")
    "f c" '((lambda () (interactive)
		(find-file "~/.config/emacs/config.org"))
		:wk "Open emacs config.org"))

    (cw/leader-keys
	"n" '(:ignore t :wk "Git")
	"n g" '(magit :wk "Open Magit UI"))
)

(use-package which-key
  :init
    (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order-alpha
	  which-key-allow-imprecise-window-fit nil
	  which-key-sort-uppercase-first nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-side-window-slot -10
	  which-key-side-window-max-height 0.25
	  which-key-idle-delay 0.8
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit nil
	  which-key-separator " → " )
    (which-key-mode))

(use-package zig-mode)

(set-face-attribute 'default nil
  :font "JetBrains Mono Nerd Font"
  :height 110
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "JetBrains Mono Nerd Font"
  :height 120
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "JetBrains Mono Nerd Font"
  :height 110
  :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono Nerd Font"))

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

(use-package transient)

(defun +elpaca-unload-seq (e)
  (and (featurep 'seq) (unload-feature 'seq t))
  (elpaca--continue-build e))

(defun +elpaca-seq-build-steps ()
  (append (butlast (if (file-exists-p (expand-file-name "seq" elpaca-builds-directory))
                       elpaca--pre-built-steps elpaca-build-steps))
          (list '+elpaca-unload-seq 'elpaca--activate-package)))

(use-package seq :ensure `(seq :build ,(+elpaca-seq-build-steps)))
(use-package magit 
  :after seq
  :ensure t)

; (let ((erc-sasl-auth-source-function #'erc-auth-source-search))
; .authinfo
(setq erc-server "irc.libera.chat"
    erc-nick "cowboy8625"
    erc-port "6667"
    erc-user-full-nme "cowboy8625"
    erc-track-shorten-start 8
    erc-autojoin-channels-alist '((
    "libera\\.chat"
    "#dailycodex"
    "#llvm"
    "#lisp"
    "#neovim"
    "#systemcrafters"
    "#emacs"
    "#zig"
    "#nyxt"
    "##rust"))
erc-hide-list '("JOIN" "PART" "QUIT")
erc-kill-buffer-on-part t
erc-auto-query 'bury)

; (let ((erc-sasl-auth-source-function #'erc-auth-source-search))
; .authinfo
(setq erc-server "irc.libera.chat"
    erc-nick "cowboy8625"
    erc-port "6667"
    erc-user-full-nme "cowboy8625"
    erc-track-shorten-start 8
    erc-autojoin-channels-alist '((
    "libera\\.chat"
    "#dailycodex"
    "#llvm"
    "#lisp"
    "#neovim"
    "#systemcrafters"
    "#emacs"
    "#zig"
    "#nyxt"
    "##rust"))
erc-hide-list '("JOIN" "PART" "QUIT")
erc-kill-buffer-on-part t
erc-auto-query 'bury)

-- TODO:

(use package lsp-mode
    :hook ('python-mode . lsp)
    :commands lsp)
