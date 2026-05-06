;;; install-deps.el --- Install dependencies for claude-code -*- lexical-binding: t; -*-

;;; Commentary:

;; This script installs the required dependencies for claude-code.
;; It can be run with: emacs -batch -l install-deps.el

;;; Code:

(require 'package)
(require 'cl-lib)

;; Add MELPA to package archives
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Initialize package system
(package-initialize)

;; List of required packages
(defvar claude-code-required-packages
  '(projectile vterm transient markdown-mode websocket)
  "List of packages required by claude-code.")

;; List of optional packages.  Failures here are not fatal so that older
;; Emacs versions (where, e.g., recent `lsp-mode' requires Emacs 29.1+)
;; can still install the core deps and run the test suite.
(defvar claude-code-optional-packages
  '(lsp-mode)
  "List of optional packages that enhance claude-code.")

;; Check if all packages are installed
(defun claude-code-all-packages-installed-p ()
  "Return t if all required and optional packages are installed."
  (cl-every #'package-installed-p
            (append claude-code-required-packages
                    claude-code-optional-packages)))

;; Install missing packages
(defun claude-code-install-packages ()
  "Install required packages and attempt to install optional ones."
  ;; Refresh package contents only if needed
  (unless (claude-code-all-packages-installed-p)
    (message "Refreshing package contents...")
    (package-refresh-contents))

  ;; Install required packages -- failures abort
  (dolist (pkg claude-code-required-packages)
    (unless (package-installed-p pkg)
      (message "Installing %s..." pkg)
      (package-install pkg)))

  ;; Install optional packages -- log and continue on failure
  (dolist (pkg claude-code-optional-packages)
    (unless (package-installed-p pkg)
      (message "Installing optional package %s..." pkg)
      (condition-case err
          (package-install pkg)
        (error
         (message "Skipping optional package %s: %s"
                  pkg (error-message-string err))))))

  (message "Dependency installation complete."))

;; Run installation
(claude-code-install-packages)

(provide 'install-deps)
;;; install-deps.el ends here
