## <img src="http://placehold.jp/28/39aaff/ffffff/180x40.png?text=fishingz">
fishingz = ファイルシステム全てに高速アクセスするための fish shell 専用のプラグイン。  
次の特徴を持つ。 

### :whale: パス情報(以降、DB とする)を使って高速に全ファイルシステムにアクセスする  
```diff
+ 選択したパスが「ディレクトリ」であれば、cd を実行する
+ 選択したパスが「ファイル」であれば、ファイル種別に応じてお気に入りのエディタやブラウザで開く
```
### :whale: DB からファイルパスのみのコピー&ペーストも可能(X Windows が必要)
```diff
+ grep や cp, mv などでパスが必要となる場合の支援をする。
```
### :whale: DB は cron, at 等のスケジューラ無しで自動更新する
```diff
- 初回のみ、手動による DB 構築が必要となる。
+   - ただし、並列探索により DB 構築時間の短縮化を実現している。
+ 2回目以降(自動更新時)は、マシン負荷を減して DB を再構築する。
+   - マシン負荷調整は可能である
```
### :whale: fishingz は root権限を使わないで実現しているので、所有 PC 以外でも使用可能   
```diff
+ 必須ソフトは fzf であるが、非管理者であってもローカル上に導入できる。  
+ 推奨ソフトである xclip, xsel についてもローカル上に導入できる(はず)
```
### :whale: Vim の Unite, Emacs の Anything のような操作性を持つ。 
```diff
+ 以下のように Unite に似た操作性となっている
C-u C-u ：「ディレクトリ」「ファイル」「シンボリックリンク」「履歴」全てを含む DB を使用する
C-u C-i ：「ディレクトリ」のみを含む DB を使用する。
C-u C-f ：「ファイル」のみを含む DB を使用する。
C-u C-l ：「シンボリックリンクファイル」のみを含む DB を使用する。
C-u C-m ：「履歴」のみを含む DB を使用する。
```
　
 
## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=デモ">
### /etc/apache2/sites-enabled ディレクトリに移動する
#### :fish: 1　DB を開く
+ カレントパスは $HOME/Videos である
![open_a_locatedb](https://user-images.githubusercontent.com/39640214/41501398-9ff0be4e-71de-11e8-8720-41733d6c0f7e.gif)
　
#### :fish: 2　/etc/apache2/sites-enabled を選択する
+ fzf により絞り込み、所望のディレクトリパスを選択することで cd 実行が可能である
+ 下図では /etcapac2site としてディレクトリを絞り込み、[d]  /etc/apache2/sites-enabled を選択して、cd 
![select_dir](https://user-images.githubusercontent.com/39640214/41502097-6ecb9834-71ed-11e8-804e-0cdfd8f8f102.gif)
　
 
## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=詳細">
### :fish: 1　選択したパスに対してアクションを実行する
fzf ウィンドウに表示されたシステム全てのパスに対して以下のアクションを実行します。  
Unite (Vim) の Action に該当する部分です。
```diff
+ ディレクトリであれば cd を実行して移動する  
+ ファイルであれば 関連付けたエディタで開く  
+   - file -b -i の結果ごとに関連付けが可能である   
-     (が、現状はコードに直書きする必要がある)
+   - 読み取り専用ファイルであっても、設定により sudo モードでアクセスすることも可能である  
+   - 関連付けしていない場合でも、ユーティリティ(例 xdg-open )を使って操作成功率を高めることが可能である。
+ シンボリックリンクであれば、ディレクトリかファイルかを判別して上記いずれかの処理を行う  
+ パスをクリップボードにコピーする (X Windows ありの場合のみ)    
+   - Ctrl-e によるクリップボードへのコピーが可能である
-     (クリップボードへのコピー実施後のカーソル位置の(表示上の)復旧が未対応である)
```
　
### :fish: 2　DB 構築を行う    
ファイルシステム全体に対してパスの収集を行い DB を作成する。  
パス収集については以下の留意点がある。
```diff
- 収集可能なパスはユーザがアクセス可能なパスに限定される  
- 初期設定では /home と /etc 以外 (/proc, /tmp, /sys, /lib,... など) パス収集の対象外としている  
- 初回の DB 構築 (パス情報収集) は手動で行う   
+   - 構築速度を優先してマシンスペックを最大限使って実施する  
+ 2回目以降の DB 構築は低負荷モードで自動的に実施させる
+   - 負荷の調整は可能である
+ 自動更新のために cron, at などのタスクスケジューラを稼動させる必要はない
+   - 所定の回数だけ fishingz を使えば、DB の再構築をさせることも可能
```

　
## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Install">

### :tropical_fish:　　Git を使ってインストールする
```console  
git clone https://nekochango@github.com/nekochango/fishingz  
cp -p ./fishingz/fishingz.fish $HOME/.config/fish/function/.  
```  
　
**必要なソフトウェア**
```diff
+ 　　　fish (2.7 以上を推奨する. 2.3.0 )
+ 　　　fzf  
+ 　　　tac (万一なければ)
+ 　　　xclip もしくは xsel (必須ではないが、無ければ使用できない機能がある)
```  
　
 　
## <img src="http://placehold.jp/24/39aaff/ffffff/240x40.png?text=Setup">
### :tropical_fish:　1.　ショートカットキーと fishingz を関連付ける
以下の要領で Fish の fish_user_key_bindings.fish ファイルにキーバインディングを定義。  
　  
例) 下記例でキーバインドの設定をする場合  
```diff
+ 以下のように Unite に似た操作性となっている
C-u C-u ：「ディレクトリ」「ファイル」「シンボリックリンク」「履歴」全てを含む DB を使用する
C-u C-i ：「ディレクトリ」のみを含む DB を使用する。
C-u C-f ：「ファイル」のみを含む DB を使用する。
C-u C-l ：「シンボリックリンクファイル」のみを含む DB を使用する。
C-u C-m ：「履歴」のみを含む DB を使用する。
```
　  
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
　
　
### :tropical_fish:　2. DB を作成する
次にファイルシステム全体のパスを収集しファイルに保存します。  
デフォルトの保存先は $HOME/.fishingz/ 以下です。  
```console  
fishingz -i
```
以下のようなログが表示されれば成功です。
```
Searching directories ... [37939]
Searching files ....  [235502]
Searching symbolic links ....  [58027]
```

### ：tropical_fish:　3. ユーザ設定をする
ユーザによって異なる設定を行う。設定ファイルは以下である。

***$HOME/.fishingz/init.fish***
+ FISHINGZ_F_CMD がファイルの場合のアクションであり、下記の場合は nvim を登録している。
+ FISHINGZ_F_HTML_CMD：HTML の場合のアクションであり、google-chrome を使って開く
+ FISHINGZ_DB_REBUILD_THLD：DB の構築までの fishingz 使用上限数を定義する
+ FISHINGZ_HISTSIZE：C-u C-u 実施時に表示する MRU の個数
+ FISHINGZ_TOGGLE_USE_SUDO： ReadOnly ファイルの場合に、sudo を使うように定義する
+ FISHINGZ_TOGGLE_EXEC_MODE： 実行ファイルの場合に、実行するかどうかを定義する
+ FISHINGZ_NPROC_ON_REBUILD：DB 再構築時に使用する CPU の個数
+ FISHINGZ_FZF_COLOR：DB 選択画面の
```
# Command to execute in case of [f]
set -g FISHINGZ_F_CMD             "nvim"
set -g FISHINGZ_F_HTML_CMD        "google-chrome"

# It represents how many times fishingz is updated when it is updated
set -g  FISHINGZ_DB_REBUILD_THLD  50      # 50 <default>
set -g  FISHINGZ_HISTSIZE         10      # 10 <default>

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



|表示|C-u C-u を実行する<br>行頭[d]がディレクトリである。<br>行頭[H]がfishingzで直近実行したコマンドである。<br>色設定は fishingz.fish で定義しているので必要に応じて変える。|
|---|:--|
|![fishingz_1](https://user-images.githubusercontent.com/39640214/41203061-26f782b4-6d0d-11e8-8db7-11613306e2bb.jpg)|

|抽出|fzf により絞り込みを行う<br>行頭[f]がファイルである。<br>行頭[l]がシンボリックリンクである。|
|---|:--|
|　　|![fishingz_1](https://user-images.githubusercontent.com/39640214/41202833-d7a26808-6d09-11e8-85a4-bcfc6effaaed.jpg)|

|決定|該当行で Enter キーを押下する。<br/>このときに今回実行したコマンドが次に [H]として表示される。|
|---|:--|
|　　|![fishingz_1 5](https://user-images.githubusercontent.com/39640214/41203287-ece6163c-6d0f-11e8-9d32-16581cf49c97.jpg)|

|完了後|次に C-u C-u を実行すると以下のように <b>[H]  cd /etc/apache2/sites-available/000-default.conf.d</b>が登録されている。|
|---|---|
||![fishingz_1 8](https://user-images.githubusercontent.com/39640214/41203500-d1005b32-6d12-11e8-93dd-20849ea3c6c7.png)|
　
 

### :cat2: Bug: Ctrl-e でクリップボードにコピーした後にコマンドラインに戻るとカーソル位置が不正である。
- 行頭に戻っているように見えるが、実際は fishingz を呼び出す前の状態の位置にいる。
- 従って、ペーストすれば正しい位置に実行はできている。
- fzf で画面を切り替えてからコマンドラインに戻ったときに、元の位置に戻す方法がご存知の方がいましたら、お教えください。


