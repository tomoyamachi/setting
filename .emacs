;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;load-path設定;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path (append
                 '("~/.emacs.d"
;                   "/usr/share/emacs/23/site-lisp/erlang"
;                   "/usr/share/emacs/23/site-lisp/prolog-el"
;                   "/usr/share/emacs/23/site-lisp/haskell-mode"
                   "/usr/local/share/emacs/23.3/site-lisp/skk")
                 load-path))
;;;~/.emacs.d/以下のディレクトリをすべてload-pathに追加;;;;;;;;;;;;;;;;;;;
(require 'cl)
(loop for f in (directory-files "~/.emacs.d" t)
      when (and (file-directory-p f)
		(not (member (file-name-nondirectory f) '("." ".."))))
      do (add-to-list 'load-path f))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;基本設定;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key global-map (kbd "C-h") 'delete-backward-char) ; 削除
(define-key global-map (kbd "M-?") 'help-for-help)        ; ヘルプ
(define-key global-map (kbd "C-z") 'undo)                 ; undo
(define-key global-map (kbd "C-c i") 'indent-region)      ; インデント
(define-key global-map (kbd "C-c C-i") 'hippie-expand)    ; 補完
(define-key global-map (kbd "C-c ;") 'comment-dwim)       ; コメントアウト
(define-key global-map (kbd "C-o") 'toggle-input-method)  ; 日本語入力切替
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
(global-set-key "\M-n" 'find-file-other-frame);;M-nで別窓でファイルを開く
(global-set-key "\C-m" 'newline-and-indent);; 改行時にインデント

(set-language-environment 'Japanese);; set language Japanese
(prefer-coding-system 'utf-8);; UTF-8

(setq text-mode-hook 'turn-off-auto-fill)

;; 同名のファイルの場合ディレクトリ名を付ける
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;;http://www.emacswiki.org/emacs/RevertBuffer
(global-auto-revert-mode 1);;;自動でrevert-buffer
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))
(global-set-key "\C-R" 'revert-buffer-no-confirm);; バッファ一覧の情報をさらに表示

;dabbrev
;; http://d.hatena.ne.jp/itouhiro/20091122    http://d.hatena.ne.jp/peccu/20100221/dabbrev
(defadvice dabbrev-expand (around jword (arg) activate)
   (interactive "*P")
   (let* ((regexp dabbrev-abbrev-char-regexp)
          (dabbrev-abbrev-char-regexp regexp)
          char ch)
     (if (bobp)
         ()
       (setq char (char-before)
             ch (char-to-string char))
       (cond
        ;; ァ～ヶの文字にマッチしてる時はァ～ヶが単語構成文字とする
        ((string-match "[ァ-ヶー]" ch)
         (setq dabbrev-abbrev-char-regexp "[ァ-ヶー]"))
        ((string-match "[ぁ-んー]" ch)
         (setq dabbrev-abbrev-char-regexp "[ぁ-んー]"))
        ((string-match "[亜-瑤]" ch)
         (setq dabbrev-abbrev-char-regexp "[亜-瑤]"))
        ;; 英数字にマッチしたら英数字とハイフン(-)を単語構成文字とする
        ((string-match "[A-Za-z0-9]" ch)
         (setq dabbrev-abbrev-char-regexp "[A-Za-z0-9-]")) ; modified by peccu
        ((eq (char-charset char) 'japanese-jisx0208)
         (setq dabbrev-abbrev-char-regexp
               (concat "["
                       (char-to-string (make-char 'japanese-jisx0208 48 33))
                       "-"
                       (char-to-string (make-char 'japanese-jisx0208 126 126))
                       "]")))))
     ad-do-it))
(global-set-key "\C-i" 'dabbrev-expand)


;tramp有効にする。ssh/sudoでのファイル編集を有効に
(add-to-list 'load-path "/usr/share/emacs/23.3/lisp/net/")
(require 'tramp)
(setq tramp-default-method "ssh")
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '("localhost" nil nil))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))

(tool-bar-mode 0);;; ツールバーを出さない
(transient-mark-mode 1);リージョンを見易く
(delete-selection-mode 1);regionをBS,DELキーで一括削除
(setq inhibit-startup-message t);; 起動時のメッセージを非表示
(setq backup-inhibited t);;; バックアップファイルを作らない
(setq delete-auto-save-files t);; バックアップファイルを作らない
(setq auto-save-dafault nil);;; オートセーブファイルを作らない
(add-hook 'before-save-hook 'delete-trailing-whitespace);;; 行末の空白を保存前に削除。
(icomplete-mode 1);;; 補完可能なものを随時表示
(column-number-mode t);;; カーソルの位置を表示する
(line-number-mode t);;; カーソルの位置を表示する
(setq-default indent-tabs-mode nil);; Tabの代わりにスペースでインデント
(setq-default tab-width 2 indent-tabs-mode nil);; Tabの幅をスペース2つ分に
(show-paren-mode 1);; 対応する括弧を光らせる。
(set-face-attribute 'default nil :height 100);;フォントのheight設定
(global-set-key "\C-x\C-b" 'bs-show);; バッファ一覧の情報をさらに表示
(defalias 'yes_or_no_p 'y_or_n_p);;; yes_or_no=>y_or_n
(setq history-length 1000);;ミニバッファ履歴リスト
(setq gc-cons-threshold (* 10 gc-cons-threshold));;ガベッジコレクションの頻度を下げる
(setq x-select-enable-clipboard t);X11とクリップボードを共有

;;; Shift + 矢印 でバッファ移動
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;;; セッションを保存する
;;; 初めは手動でM-x desktop-saveしなければいけない
(autoload 'desktop-save "desktop" nil t)
(autoload 'desktop-clear "desktop" nil t)
(autoload 'desktop-load-default "desktop" nil t)
(autoload 'desktop-remove "desktop" nil t)
(desktop-load-default)
;; C-x bでミニバッファにバッファ候補を表示
(iswitchb-mode t)
(iswitchb-default-keybindings)
;; terminalでファイルを開くときにemacsで開けるようにする
;; .bashrcに「alias e='emacsclient -n'」と書く
(if window-system (server-start))


;;表示されているバッファを入れ替える。
(defun swap-screen()
  "Swap two screen,leaving cursor at current window."
  (interactive)
  (let ((thiswin (selected-window))
        (nextbuf (window-buffer (next-window))))
    (set-window-buffer (next-window) (window-buffer))
    (set-window-buffer thiswin nextbuf)))
(defun swap-screen-with-cursor()
  "Swap two screen,with cursor in same buffer."
  (interactive)
  (let ((thiswin (selected-window))
        (thisbuf (window-buffer)))
    (other-window 1)
    (set-window-buffer thiswin (window-buffer))
    (set-window-buffer (selected-window) thisbuf)))
(global-set-key [f2] 'swap-screen)
(global-set-key [S-f2] 'swap-screen-with-cursor)

;; カーソル行をハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "DimGrey"))
    (((class color)
      (background light))
     (:background "gray"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

;; 行をコピーするコマンド
(defun copy-line (&optional arg)
  (interactive "p")
  (copy-region-as-kill
   (line-beginning-position)
   (line-beginning-position (1+ (or arg 1))))
  (message "Line copied"))
;; リージョンを選択していないときに行をキルするコマンド
(defadvice kill-region (around kill-line-or-kill-region activate)
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (kill-whole-line)
    ad-do-it))
;; リージョンを選択していないときに行をコピーするコマンド
(defadvice kill-ring-save (around kill-line-save-or-kill-ring-save activate)
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (copy-line)
    ad-do-it))

;; 括弧を自動で挿入
;; ref: http://www.emacswiki.org/cgi-bin/wiki/SkeletonMode
(require 'skeleton)
(setq skeleton-pair t)
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "<") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(add-to-list 'skeleton-pair-alist '(?` _ ?`))
(global-set-key (kbd "`") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(add-to-list 'skeleton-pair-alist '(?「 _ ?」))
(global-set-key (kbd "「") 'skeleton-pair-insert-maybe)

;;view-modeをよりつかいやすく
;; view-minor-modeの設定
(add-hook 'view-mode-hook
          '(lambda()
             (progn
               ;; C-b, ←
               (define-key view-mode-map "h" 'backward-char)
               ;; C-n, ↓
               (define-key view-mode-map "j" 'next-line)
               ;; C-p, ↑
               (define-key view-mode-map "k" 'previous-line)
               ;; C-f, →
               (define-key view-mode-map "l" 'forward-char)
               )))
;;http://www.bookshelf.jp/soft/meadow_24.html
;; - yes/no の確認なしで、ファイルの再読込み
(defun reopen-file ()
  (interactive)
  (let ((file-name (buffer-file-name))
        (old-supersession-threat
         (symbol-function 'ask-user-about-supersession-threat))
        (point (point)))
    (when file-name
      (fset 'ask-user-about-supersession-threat (lambda (fn)))
      (unwind-protect
          (progn
            (erase-buffer)
            (insert-file file-name)
            (set-visited-file-modtime)
            (goto-char point))
        (fset 'ask-user-about-supersession-threat
              old-supersession-threat)))))
;;C-rでバッファを再読込み
;(define-key ctl-x-map "\C-r"  'reopen-file)

;;;shiftキーではなく、「;→アルファベット」で大文字に変換。
;;;http://homepage1.nifty.com/blankspace/emacs/sticky.html
(defvar sticky-key ";")
(defvar sticky-list
  '(("a" . "A")("b" . "B")("c" . "C")("d" . "D")("e" . "E")("f" . "F")("g" . "G")
    ("h" . "H")("i" . "I")("j" . "J")("k" . "K")("l" . "L")("m" . "M")("n" . "N")
    ("o" . "O")("p" . "P")("q" . "Q")("r" . "R")("s" . "S")("t" . "T")("u" . "U")
    ("v" . "V")("w" . "W")("x" . "X")("y" . "Y")("z" . "Z")
    ("1" . "!")("2" . "\"")("3" . "#")("4" . "$")("5" . "%")("6" . "&")("7" . "\'")
    ("8" . "(")("9" . ")")("0" . "=")
    ("`" . "~")("[" . "{")("]" . "}")("-" . "_")("=" . "+")("," . "<")("." . ">")
    ("/" . "?")("@" . "=")("\\" . "|")
    ))
(defvar sticky-map (make-sparse-keymap))
(define-key global-map sticky-key sticky-map)
(mapcar (lambda (pair)
          (define-key sticky-map (car pair)
            `(lambda()(interactive)
               (setq unread-command-events
                     (cons ,(string-to-char (cdr pair)) unread-command-events)))))
        sticky-list)
(define-key sticky-map sticky-key '(lambda ()(interactive)(insert sticky-key)))

;; 起動時のウィンドウについて設定
(if window-system (progn
                    (setq initial-frame-alist '((width . 150)(height . 75)(top . 100)(left . 40)))
                    (set-background-color "Black")
                    (set-foreground-color "White")
                    (set-cursor-color "Gray")
                    ))

;;; line-number
(require 'linum)
(global-linum-mode t)
(setq linum-format "%5d")

;;;マウススクロールをスムーズに
;; (defun smooth-scroll (number-lines increment)
;;   (if (= 0 number-lines)
;;       t
;;     (progn
;;       (sit-for 0.02)
;;       (scroll-up increment)
;;        (smooth-scroll (- number-lines 1) increment))))
;; (global-set-key [(mouse-5)] '(lambda () (interactive) (smooth-scroll 6 1)))
;; (global-set-key [(mouse-4)] '(lambda () (interactive) (smooth-scroll 6 -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;for package;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ddskk
(require 'skk-autoloads)
(global-set-key "\C-o" 'skk-mode)
;(global-set-key "\C-x\C-j" 'skk-auto-fill-mode)
(global-set-key "\C-xt" 'skk-tutorial)
(setq skk-show-inline t)
(setq skk-large-jisho "~/.emacs.d/skk-jisyo/SKK-JISYO.ML")
(setq skk-egg-like-newline t)
(setq skk-auto-insert-paren t)
(setq skk-dcomp-activate t)
(setq skk-date-ad t)
(setq skk-number-style 0)
(require 'skk-study)

(add-hook 'skk-mode-hook
	  '(lambda () (setq skk-kutouten-type 'jp-en)))

(defun skk-insert-hyphen (arg)
  (interactive "P")
  (insert
   (let (s
	 (c (char-before (point))))
     (if c (setq s (char-to-string (char-before (point)))))
     (cond ((null s) "ー")
	   ((string-match "[0-9]" s) "-")
	   ((string-match "[０-９]" s) "−")
	   (t "ー")))))

; from kitamoto tsuyoshi さん
(defun skk-period (arg)
  (let ((c (char-before (point))))
    (cond ((null c) (cadr (assoc skk-kutouten-type skk-kuten-touten-alist)))
	  ((and (<= ?0 c) (>= ?9 c)) ".")
	  ((and (<= ?０ c) (>= ?９ c)) "．")
	  (t (cadr (assoc skk-kutouten-type skk-kuten-touten-alist))))))

(defun skk-comma (arg)
  (let ((c (char-before (point))))
    (cond ((null c) (cddr (assoc skk-kutouten-type skk-kuten-touten-alist)))
	  ((and (<= ?0 c) (>= ?9 c)) ",")
	  ((and (<= ?０ c) (>= ?９ c)) "，")
	  (t (cddr (assoc skk-kutouten-type skk-kuten-touten-alist))))))

(setq skk-rom-kana-rule-list
      (nconc skk-rom-kana-rule-list
	     '(
	       ("!" nil "!")
	       (":" nil ":")
	       (";" nil ";")
	       ("?" nil "?")
	       ("-" nil skk-insert-hyphen)
	       ("." nil skk-period)
	       ("," nil skk-comma)
	       )))

;;辞書 skk サーバ用の設定
(setq skk-server-host "127.0.0.1")
(setq skk-server-portnum 1178)
(setq skk-server-report-response t);;変換時サーバーの文字を受けとるまでの accept-process-output 実行回数を表示
;;isearchでskkを
(add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
(add-hook 'isearch-mode-hook 'skk-isearch-mode-cleanup)
(setq skk-henkan-strict-okuri-precedence t);;送り仮名が厳密に正しい候補を優先して表示
(setq skk-dcomp-activate t);;日本語をダイナミックに補完する
(setq skk-use-look t);;英単語補完
(setq skk-check-okurigana-on-touroku 'auto);;余分な送り仮名も辞書に自動登録、嫌なら 'nil 質問方式なら 'ask

;; かなモードの入力でモード変更を行わずに、数字入力中の
;; 小数点 (.) およびカンマ (,) 入力を実現する。
;; (例) かなモードのまま 1.23 や 1,234,567 などの記述を行える。
;; period
(setq skk-rom-kana-rule-list
(cons '("." nil skk-period)
skk-rom-kana-rule-list))
(defun skk-period (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "。")
          ((and (<= ?0 c) (>= ?9 c)) ".")
          ((and (<= ?０ c) (>= ?９ c)) "．")
          (t "。"))))

;; comma
(setq skk-rom-kana-rule-list
(cons '("," nil skk-comma)
skk-rom-kana-rule-list))
(defun skk-comma (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "、")
          ((and (<= ?0 c) (>= ?9 c)) ",")
          ((and (<= ?０ c) (>= ?９ c)) "，")
          (t "、"))))


;;;sticky-shiftをskkでもつかう
(setq skk-sticky-key ";")

(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t)
(setq undo-limit 60000)
(setq undo-strong-limit 600000)

(require 'anything-startup)
(define-key anything-map "\C-p" 'anything-previous-line)
(define-key anything-map "\C-n" 'anything-next-line)
(define-key anything-map (kbd "C-M-n") 'anything-next-source)
(define-key anything-map (kbd "C-M-p") 'anything-previous-source)
(define-key anything-map "\C-v" 'anything-next-page)
(define-key anything-map "\M-v" 'anything-previous-page)
(define-key anything-map "\C-z" 'anything-execute-persistent-action)
(global-set-key (kbd "C-;") 'anything)

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)

(require 'recentf-ext)
(setq recentf-max-saved-items 500)
(setq recentf-exclude '("/TAGS$" "/var/tmp/"))
(when (require 'recentf nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1))

(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-file-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

;; (require 'w3m-load)
;; (setq w3m-home-page "http://www.google.co.jp/") ;起動時に開くページ
;; (setq w3m-use-cookies t) ;クッキーを使う
;; (setq w3m-bookmark-file "~/.w3m/bookmark.html") ;;ブックマークを保存するファイル


(require 'shell-pop)
(shell-pop-set-internal-mode "ansi-term")
(shell-pop-set-internal-mode-shell "/bin/bash")

(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
          (function
           (lambda ()
             (define-key term-raw-map "\C-t" 'shell-pop))))
(defadvice ansi-term (after ansi-term-after-advice (arg))
  "run hook as after advice"
  (run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)

(global-set-key "\C-t" 'shell-pop)

(setq ansi-term-color-vector
      [unspecified "black" "red1" "lime green" "yellow2"
                   "DeepSkyBlue3" "magenta2" "cyan2" "white"])


;;;;;;;;;;; org mode
;;http://lists.gnu.org/archive/html/emacs-orgmode/2010-12/msg01057.html
;; Make windmove work in org-mode:
(setq org-disputed-keys '(([(shift up)] . [(meta p)])
                          ([(shift down)] . [(meta n)])
                          ([(shift left)] . [(meta -)])
                          ([(shift right)] . [(meta +)])
                          ([(control shift right)] . [(meta shift +)])
                          ([(control shift left)] . [(meta shift -)])))
(setq org-replace-disputed-keys t)


;;
;; Evernote mode
;;http://at-aka.blogspot.com/2010/12/emacs-evernote-mode-emacs-evernote.html
;; (setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; optional
;; (require 'evernote-mode)
;; (global-set-key "\C-cec" 'evernote-create-note)
;; (global-set-key "\C-ceo" 'evernote-open-note)
;; (global-set-key "\C-ces" 'evernote-search-notes)
;; (global-set-key "\C-ceS" 'evernote-do-saved-search)
;; (global-set-key "\C-cew" 'evernote-write-note)
;; (global-set-key "\C-cep" 'evernote-post-region)
;; (global-set-key "\C-ceb" 'evernote-browser)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; programming;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ruby-mode
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.watchr$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; (require 'rspec-mode)
;; (add-to-list 'auto-mode-alist '("\\spec.rb\\'" . rspec-mode))

;; (require 'ruby-electric)
;; (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; ;(require 'ido)
;; ;(ido-mode t)
;; (require 'rinari)
;; (require 'rhtml-mode)
;; (add-hook 'rhtml-mode-hook
;;     (lambda () (rinari-launch)))
(require 'yasnippet) ;; not yasnippet-bundle
(require 'anything-c-yasnippet)
(setq anything-c-yas-space-match-any-greedy t) ;スペース区切りで絞り込めるようにする デフォルトは nil
(global-set-key (kbd "C-c y") 'anything-c-yas-complete) ;C-c yで起動 (同時にお使いのマイナーモードとキーバインドがかぶるかもしれません)

(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")
(yas/load-directory "~/.emacs.d/yasnippet/yasnippets")
;; (yas/load-directory "~/.emacs.d/yasnippets")
;; (yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets")
;; (require 'ruby-block)
;; (ruby-block-mode t)
;; (setq ruby-block-highlight-toggle t)

;;;;;;;;php-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'php-mode)
(add-hook 'php-mode-user-hook
          '(lambda ()
             (setq tab-width 2)
             (setq indent-tabs-mode nil))
          )
;; 補完のためのマニュアルのパス
(setq php-completion-file "~/.emacs.d/php.dict")
;; M-TAB が有効にならないので以下の設定を追加
(define-key php-mode-map "\C-\M-i" 'php-complete-function)
;; (add-hook 'php-mode-user-hook
;;           '(lambda ()
;;              (setq php-completion-file "~/.emacs.d/php.dict")
;;              (define-key php-mode-map (kbd "C-.") 'php-complete-function)
;;              )
;;           )

;(add-to-list 'auto-mode-alist '("\\.php$" . html-mode))

;;;;;;;;sass-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))

;;;;;;;;Prolog-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                                auto-mode-alist))
(setq prolog-system 'gnu)

;;;;;;;;scala-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'scala-mode-auto)
(require 'scala-mode-feature-electric)
    (add-hook 'scala-mode-hook
	      (lambda ()
		(scala-electric-mode)))

;;;;;;;;Erlang-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist (append '(("\\.erl$" . erlang-mode))
                                auto-mode-alist))
(setq erlang-electric-commands '())

;; ;;;;;;;;Coffee-mode;;;;;;;;;;;;;;;;;;;;;;;
(require 'coffee-mode)
;(setq coffee-program-name "/home/tomoya/.node/v0.4.10/bin/coffee")
;(setq coffee-universal-path "/home/tomoya/.node/v0.4.10/bin/coffee")
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
;;;;;;;;;swank-js
(require 'slime)
(slime-setup '(slime-repl slime-fancy slime-banner slime-js))

(global-set-key [f5] 'slime-js-reload)
(add-hook 'js2-mode-hook
          (lambda ()
            (slime-js-minor-mode 1)))

;;;;;;;haskell-mode;;;;;;;;;;;;;;;
(load "haskell-site-file")
(append auto-mode-alist
        '(("\\.hs$" . 'haskell-mode)
          ("\\.hi$" . 'haskell-mode)
          ("\\.lhs$" . 'literate-haskell-mode)))
;(setq haskell-program-name "/usr/bin/ghci")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
;;;add haml-mode to .hamljs
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
(setq auto-mode-alist (append '(("\\.hamljs$" . haml-mode))
                                auto-mode-alist))

;;http://cx4a.blogspot.com/2011/12/popwineldirexel.html
;; direx:direx-modeのバッファをウィンドウ左辺に幅25でポップアップ
;; :dedicatedにtを指定することで、direxウィンドウ内でのバッファの切り替えが
;; ポップアップ前のウィンドウに移譲される
(require 'direx)
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-:") 'direx:jump-to-directory-other-window)

;;; ELPA packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;; flymake for ruby と rvmを併用
(require 'rvm)
(rvm-use-default)
;; flymake for ruby
(require 'flymake)
;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
(add-hook
 'ruby-mode-hook
 '(lambda ()
    ;; Don't want flymake mode for ruby regions in rhtml files
    (if (not (null buffer-file-name)) (flymake-mode))
    ;; エラー行で C-c d するとエラーの内容をミニバッファで表示する
    (define-key ruby-mode-map "\C-cd" 'credmp/flymake-display-err-minibuf)))

(defun credmp/flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list))
         )
    (while (> count 0)
      (when line-err-info-list
        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)
          )
        )
      (setq count (1- count)))))

;; (setq flymake-coffeescript-err-line-patterns
;;   '(("\\(Error: In \\([^,]+\\), .+ on line \\([0-9]+\\).*\\)" 2 3 nil 1)))

;; (defconst flymake-allowed-coffeescript-file-name-masks
;;   '(("\\.coffee$" flymake-coffeescript-init)))

;; (defun flymake-coffeescript-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "coffee" (list local-file))))

;; (defun flymake-coffeescript-load ()
;;   (interactive)
;;   (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;;     (setq flymake-check-was-interrupted t))
;;   (ad-activate 'flymake-post-syntax-check)
;;   (setq flymake-allowed-file-name-masks
;;         (append flymake-allowed-file-name-masks
;;                 flymake-allowed-coffeescript-file-name-masks))
;;   (setq flymake-err-line-patterns flymake-coffeescript-err-line-patterns)
;;   (flymake-mode t))

;; (add-hook 'coffee-mode-hook 'flymake-coffeescript-load)

