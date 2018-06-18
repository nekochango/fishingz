# <img src="http://placehold.jp/32/39aaff/000000/180x40.png?text=fishingz">
ファイルシステム全てに高速アクセスするための fish shell 専用のプラグイン。　　
事前に収集したパス情報(以降、DB とする)を基にしてアクセスをする。

　

## <img src="http://placehold.jp/32/39aaff/444444/180x40.png?text=contents">
<b><a href="#-1">特徴</a></b><br/>
<b><a href="#-2">デモ</a></b><br/>
<b><a href="#-3">インストール手順</a></b><br/>
<b><a href="#-4">セットアップ手順</a></b><br/>
<b><a href="#-5">高度な設定</a></b><br/>

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=特徴">
### :whale: DB を使った高速アクセス
```diff
+ DB をオープンして目的のパスを選択する。
+　　- アクセスの度にパスの洗い出し(findコマンド実施)はしない
+ 選択したパスの種類に応じて以下のように処理が自動的に実行される。
+　　-「ディレクトリ」であれば、cd を実行する
+　　- HTML であれば Web ブラウザで開く
+　　- Text であれば お気に入りのエディタで開く
```

### :whale: DB からパスのみ取得する
```diff
+ Ctrl-e とすることで, カーソル下のパスを clipboard にコピーしてくれる
+ コピー後はコマンドラインに戻るので Shift-Insert などでペーストができる
+　　- これにより取得したパスを grep, cp, mv, diff, ls などの引数にできる
```

### :whale: 初回の DB 構築は高速化対応を施した
```diff
+ DB 初回作成時のみマシンスペックを最大限に使って
```

### :whale: 2回目以降の DB 更新は自動的に行われる
```diff
+ 一定回数だけ fishingz を使えば DB の自動更新が行われる
+　　- DB 更新までの閾値は自由に設定可能である
+　　- DB 再構築時はバックグラウンドでマシン負荷を減らして行われる (負荷変更も可能)
+　　- 更新契機が簡単なため、cron, at 等のスケジューラ登録が不要である
```

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=デモ">
### /etc/apache2/sites-enabled ディレクトリに移動する
#### :fish: 1　DB を開く
+ コマンドラインから C-u C-u と入力することで DB をオープンする。(キーは変更可能) 
![open_a_locatedb](https://user-images.githubusercontent.com/39640214/41501398-9ff0be4e-71de-11e8-8720-41733d6c0f7e.gif)

#### :fish: 2　パスを選択する
+ fzf により /etcapac2site として絞り込みを行う。  
+ 目標の <b>[d]  /etc/apache2/sites-enabled </b>を選択する。  
+ 以上の操作で<b> cd /etc/apache2/sites-enabled </b>が実行された。
![select_dir](https://user-images.githubusercontent.com/39640214/41502097-6ecb9834-71ed-11e8-804e-0cdfd8f8f102.gif)

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Install">

### :tropical_fish:　　必要なソフトウェア
```diff
+ 　　　fish (推奨 2.7 以上。 2.2 は不可)
+ 　　　fzf  
+ 　　　xclip もしくは xsel
```  

### :tropical_fish:　　1.　fishingz のインストールをする
```console  
git clone https://nekochango@github.com/nekochango/fishingz  
cp -p ./fishingz/fishingz.fish $HOME/.config/fish/function/.  
```
```console
source $HOME/.config/fish/functions/fishingz.fish
```

### :tropical_fish:　　2.　fzf のインストールをする
- [fzf　:mag:](https://github.com/junegunn/fzf#using-git)
```console
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### :tropical_fish:　　3.　xclip のインストールをする
- [xclip　:mag:](https://github.com/astrand/xclip)  

管理者権限が無い場合は、コンパイルをして xclip を作成する。  
```console
git clone https://github.com/astrand/xclip
autoreconf		# create configuration files
./configure		# create the Makefile
make			# build the binary
```

管理者権限がある場合は<b>apt-get install</b>でインストールする。  
```console
apt-get install -y xclip
```

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Setup">


### :tropical_fish:　　1.　fishingz を呼び出すためのキーバインディングをする

|キー|対応コマンド|処理内容|
|---|---|:--|
|C-u C-u|fishingz|「ディレクトリ」「ファイル」「シンボリックリンク」「履歴」全てを含む DB を使用する。|
|C-u C-i|fishingz --find-dir|「ディレクトリ」のみを含む DB を使用する。|
|C-u C-f|fishingz --find-file|「ファイル」のみを含む DB を使用する。|
|C-u C-l|fishingz --find-link|「シンボリックリンクファイル」のみを含む DB を使用する。|
|C-u C-m|fishingz --find-mru|「履歴」のみを含む DB を使用する。|

　

上表の設定をする場合は以下のように記述すること。  
　

***$HOME/.config/fish/functions/fish_user_key_bindings.fish***  
```diff
  function fish_user_key_bindings  
    ### fishingz ###  
+   bind \cu\cu 'fishingz             ; commandline -f repaint'
+   bind \cu\ci 'fishingz --find-dir  ; commandline -f repaint'
+   bind \cu\cf 'fishingz --find-file ; commandline -f repaint'
+   bind \cu\cl 'fishingz --find-link ; commandline -f repaint'
+   bind \cu\cm 'fishingz --find-mru  ; commandline -f repaint'

    fzf_key_bindings
    ### fzf ###
    if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
        bind \ct '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \ec '__fzf_cd'
        bind \eC '__fzf_cd --hidden'
(-- snip --)
```

　

### :tropical_fish:　　2.　DB を構築する
```console
fishingz -i
```
なお、初期設定では下記ファイルシステムは探索対象外としている。
```
/lost+found 　/snap 　/proc 　/sbin 　/media 　/root 　/opt
/srv 　/cdrom 　/lib64 　/mnt 　/run 　/tmp 　/lib 　/dev
```

以上で fishingz が使用可能になった。

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Advanced%20Setup">


以下は必要に応じて行えば良い。
　 

### :dolphin:　　1.　fishingz の設定をする

設定ファイルは $HOME/.fishingz/init.fish である。

|変数|処理内容|デフォルト値|
|---|:--|:--|
|FISHINGZ_F_CMD|テキストファイルの場合に使用したいアプリケーション|nano|
|FISHINGZ_F_HTML_CMD|HTMLの場合に使用したいアプリケーション|firefox|
|FISHINGZ_DB_REBUILD_THLD|DB 再構築までに必要とする fishingz の使用回数|50|
|FISHINGZ_TOGGLE_USE_SUDO|読み取り専用の場合に sudo を使うか？(0:使わない、1:使う)|0:使わない|
|FISHINGZ_NPROC_ON_REBUILD|DB 再構築時に使用する CPU の個数|1個|
|FISHINGZ_COLOR_D|DB オープン時のディレクトリの表示色|32m (green)|
|FISHINGZ_COLOR_F|DB オープン時のファイルの表示色|36m (cyan)|
|FISHINGZ_COLOR_L|DB オープン時のシンボリックリンクの表示色|35m (purple)|
|FISHINGZ_COLOR_M|DB オープン時の MRU の表示色|33m (yellow)|
|FISHINGZ_FZF_COLOR|fzfモード時の色設定||
|

　

上表の設定をする場合は以下のように記述すること。  
　

***$HOME/.fishingz/init.fish***  
```
# Command to execute in case of [f]
set -g FISHINGZ_F_CMD             "vim"
set -g FISHINGZ_F_HTML_CMD        "google-chrome"

# It represents how many times fishingz is updated when it is updated
set -g  FISHINGZ_DB_REBUILD_THLD  50      # 50 <default>

# use sudo, when you can not writ file (1:use sudo, 0: not use <default> )
set -g FISHINGZ_TOGGLE_USE_SUDO   1

# execute it, if it have +x permission (1:execute,  0: not execute <default> )
set -g FISHINGZ_TOGGLE_EXEC_MODE  0

# Number of Core to use when rebuilding DB
set -g FISHINGZ_NPROC_ON_REBUILD  1

# fzf color settings.
# 30:black, 31:red, 32:green, 33:yellow, 34:blue, 35:magenta, 36:cyan, 37:white 
set -g  FISHINGZ_COLOR_D  32m       # [d] directory
set -g  FISHINGZ_COLOR_F  36m       # [f] file
set -g  FISHINGZ_COLOR_L  35m       # [l] symlink
set -g  FISHINGZ_COLOR_H  33m       # [H] MRU
set -g  FISHINGZ_FZF_COLOR "--color=hl:#ff00b0,bg+:#666666"
```

　
