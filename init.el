;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE SOURCE SETUP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(when (not (member "elpa" (directory-files "~/.emacs.d")))
  (package-refresh-contents))
(defun check-installed (p)
  (when (not (package-installed-p p))
    (package-install p)))

(load-file "~/.emacs.d/website.el")     ;; func to make blog post
(load-file "~/.emacs.d/mu4e-config.el") ;; email configuration

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq gc-cons-threshold 33554432) ; 32MB before garbage collection
(setq inhibit-splash-screen t
      initial-scratch-message nil)

(global-linum-mode t) ;; line numbers
(setq linum-format "%3d ")
(column-number-mode t)

(show-paren-mode t)
(setq show-paren-delay 0)

(setq auto-save-default t ;; auto save
      make-backup-files nil)

(setq indent-tabs-mode nil ;; tabs
      tab-width 4)

(setq-default show-trailing-whitespace t) ;; i hate it
(global-set-key (kbd "<f12>") 'delete-trailing-whitespace)

(tool-bar-mode -1) ;; gui / style
(menu-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun asj/comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current"
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-/") 'asj/comment-or-uncomment-region-or-line)

(defun asj/disable-special ()
  (interactive)
  (setq show-trailing-whitespace nil)
  (linum-mode -1))

(defun asj/set-font-size (n)
  (interactive "nFont Size: ")
  (set-face-attribute 'default nil :height (* n 10)))

;; By Bozhidar Batsov
(defun google ()
 "Google the selected region if any, display a query prompt otherwise."
 (interactive)
 (browse-url
  (concat
   "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
   (url-hexify-string (if mark-active
			  (buffer-substring
			   (region-beginning) (region-end))
			  (read-string "Search Google: "))))))
(global-set-key (kbd "C-x g") 'google)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SPELL CHECKING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PLAIN TEXT EDITING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LATEX EDITING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(check-installed 'auctex)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(check-installed 'company)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WEB DEVELOPMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(check-installed 'web-mode)
(add-hook 'web-mode-hook
          '(lambda ()
             (setq web-mode-markup-indent-offset 2
                   web-mode-css-indent-offset 2
                   web-mode-code-indent-offset 2)))
(add-to-list 'auto-mode-alist  '("\\.php\\'" . web-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IRC/ERC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'erc-mode-hook 'asj/disable-special)
(setq erc-nick "asjackson"
      erc-server "irc.freenode.net"
      erc-log-channels-directory "~/irc/"
      erc-save-buffer-on-part t
      erc-save-queries-on-quit t)
(add-hook 'erc-mode 'asj/disable-special)
