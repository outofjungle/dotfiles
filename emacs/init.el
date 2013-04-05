;; 14pt font size
(set-face-attribute 'default nil :height 140)

;; default tab width 
(setq-default tab-width 4)

;; just spaces
(setq-default indent-tabs-mode nil)

;; Use cperl-mode instead of the default perl-mode
(defalias 'perl-mode 'cperl-mode)

;; Use 4 space indents via cperl mode
(custom-set-variables
  '(cperl-close-paren-offset -4)
  '(cperl-continued-statement-offset 4)
  '(cperl-indent-level 4)
  '(cperl-indent-parens-as-block t)
  '(cperl-tab-always-indent t)
)
