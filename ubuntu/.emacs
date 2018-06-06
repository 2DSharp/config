(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" default)))
 '(save-place t nil (saveplace))
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "unspecified-bg" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default"))))
 '(font-lock-comment-face ((t (:foreground "brightblack"))))
 '(font-lock-constant-face ((t (:foreground "color-42"))))
 '(font-lock-doc-face ((t (:foreground "brightblack"))))
 '(font-lock-function-name-face ((t (:foreground "color-38"))))
 '(font-lock-keyword-face ((t (:foreground "color-177"))))
 '(font-lock-preprocessor-face ((t (:inherit font-lock-builtin-face :foreground "color-162"))))
 '(font-lock-string-face ((t (:foreground "color-191"))))
 '(font-lock-type-face ((t (:foreground "color-222"))))
 '(font-lock-variable-name-face ((t (:foreground "color-167"))))
 '(linum ((t (:inherit (shadow default) :foreground "color-23" :width condensed))))
 '(linum-highlight-face ((t (:inherit default :background "black" :foreground "cyan"))))
 '(magit-section-heading ((t (:foreground "color-82" :weight bold :family "Arial"))))
 '(magit-section-highlight ((t (:background "brightblack"))))
 '(message-header-subject ((t (:foreground "brightyellow" :weight bold))))
 '(message-header-to ((t (:foreground "brightred" :weight bold))))
 '(minibuffer-prompt ((t (:foreground "cyan"))))
 '(mode-line ((t (:background "Black" :foreground "yellow" :box nil))))
 '(vertical-border ((t (:inherit mode-line-inactive :background "black" :foreground "black" :width condensed))))
 '(web-mode-html-attr-name-face ((t (:foreground "cyan"))))
 '(web-mode-html-attr-value-face ((t (:foreground "color-77"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground "brightblack"))))
 '(web-mode-html-tag-face ((t (:foreground "color-167")))))
(define-key global-map (kbd "C-c <up>") 'windmove-up)
(define-key global-map (kbd "C-c <down>") 'windmove-down)
(define-key global-map (kbd "C-c <left>") 'windmove-left)
(define-key global-map (kbd "C-c <right>") 'windmove-right)
(global-linum-mode t)
(setq linum-format "%4d  ")
(require 'package)
(add-to-list 'package-archives
              '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(global-flycheck-mode)
(require 'auto-complete)
(global-auto-complete-mode t)
(global-set-key (kbd "<C-up>") 'shrink-window)
(global-set-key (kbd "<C-down>") 'enlarge-window)
(global-set-key (kbd "<C-right>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-left>") 'enlarge-window-horizontally)
(set-face-attribute 'mode-line nil
		    :foreground "brightyellow"
		    :background "Black"
		    :box nil)
(menu-bar-mode -1)
(set-face-background 'vertical-border "black")
(set-face-foreground 'vertical-border "green")
(set-face-background 'modeline-inactive "black")
(set-face-foreground 'modeline-inactive "brightblue")
(setq max-mini-window-height 1)
(require 'hlinum)
(hlinum-activate)
(add-to-list 'default-frame-alist '(font . "Arial"))
(set-face-foreground 'font-lock-string-face "brightyellow")
(set-face-foreground 'font-lock-comment-face "brightblack")
(setq x-select-enable-clipboard t)

(add-hook 'php-mode-hook 'my-php-mode-stuff)

(defun my-php-mode-stuff ()
  (local-set-key (kbd "<f1>") 'my-php-function-lookup)
  (local-set-key (kbd "C-<f1>") 'my-php-symbol-lookup))


(defun my-php-symbol-lookup ()
  (interactive)
  (let ((symbol (symbol-at-point)))
    (if (not symbol)
	(message "No symbol at point.")

      (browse-url (concat "http://php.net/manual-lookup.php?pattern="
			  (symbol-name symbol))))))


(defun my-php-function-lookup ()
  (interactive)
  (let* ((function (symbol-name (or (symbol-at-point)
				    (error "No function at point."))))
	 (buf (url-retrieve-synchronously (concat "http://php.net/manual-lookup.php?pattern=" function))))
    (with-current-buffer buf
      (goto-char (point-min))
      (let (desc)
	(when (re-search-forward "<div class=\"methodsynopsis dc-description\">\\(\\(.\\|\n\\)*?\\)</div>" nil t)
	  (setq desc
		(replace-regexp-in-string
		 " +" " "
		 (replace-regexp-in-string
		  "\n" ""
		  (replace-regexp-in-string "<.*?>" "" (match-string-no-properties 1)))))

	  (when (re-search-forward "<p class=\"para rdfs-comment\">\\(\\(.\\|\n\\)*?\\)</p>" nil t)
	    (setq desc
		  (concat desc "\n\n"
			  (replace-regexp-in-string
			   " +" " "
			   (replace-regexp-in-string
			    "\n" ""
			    (replace-regexp-in-string "<.*?>" "" (match-string-no-properties 1))))))))

	(if desc
	    (message desc)
	  (message "Could not extract function info. Press C-F1 to go the description."))))
    (kill-buffer buf)))

(defun my-fetch-php-completions ()
  (if (and (boundp 'my-php-symbol-list)
	   my-php-symbol-list)
      my-php-symbol-list

    (message "Fetching completion list...")

    (with-current-buffer
	(url-retrieve-synchronously "http://www.php.net/manual/en/indexes.functions.php")

      (goto-char (point-min))

      (message "Collecting function names...")

      (setq my-php-symbol-list nil)
      (while (re-search-forward "<a[^>]*class=\"index\"[^>]*>\\([^<]+\\)</a>" nil t)
	(push (match-string-no-properties 1) my-php-symbol-list))

      my-php-symbol-list)))
(add-hook 'php-mode-hook (lambda ()
			   (defun ywb-php-lineup-arglist-intro (langelem)
			     (save-excursion
			       (goto-char (cdr langelem))
			       (vector (+ (current-column) c-basic-offset))))
			   (defun ywb-php-lineup-arglist-close (langelem)
			     (save-excursion
			       (goto-char (cdr langelem))
			       (vector (current-column))))
			   (c-set-offset 'arglist-intro 'ywb-php-lineup-arglist-intro)
			   (c-set-offset 'arglist-close 'ywb-php-lineup-arglist-close)))

(add-hook 'php-mode-common-hook
	  (lambda ()
	                 (c-set-offset 'case-label '+)))
(add-hook 'php-mode-hook 
  (lambda () (c-set-offset 'case-label 4)))

(c-set-offset 'case-label 4)
(c-set-offset 'statement-case-intro 4)
(add-to-list 'display-buffer-alist
	     `(,(rx bos "*Flycheck errors*" eos)
	       (display-buffer-reuse-window
		display-buffer-in-side-window)
	       (side            . bottom)
	       (reusable-frames . visible)
	                     (window-height   . 0.33)))


(defvar user-custom-dir (getenv "EMACS_USER_DIR"))

(when (/= (length user-custom-dir) 0)
  (setq user-emacs-directory (file-name-as-directory user-custom-dir)))

(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))
;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
          (add-hook 'org-shiftright-final-hook 'windmove-right)
(setq org-log-done 'time)
(setq org-log-done 'note)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
;;(set-face-background 'fringe "green")
;;(setq-default top-margin-width 100 ) ; Define new widths.
;; (set-window-buffer nil (current-buffer)) ; Use them now.
;; These two lines are just examples
;;(setq powerline-arrow-shape 'curve)
;;(setq powerline-default-separator-dir '(right . left))
;; These two lines you really need.
;;(setq sml/theme 'powerline)
;;(sml/setup)
;;(require 'workgroups)
;;(setq wg-prefix-key (kbd "C-c w"))
;;(workgroups-mode 1)
;;(wg-load "~/workgroups")
;;(desktop-save-mode 1)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)



