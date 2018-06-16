## <img src="http://placehold.jp/28/39aaff/ffffff/180x40.png?text=fishingz">
fishingz はファイルシステム全てに高速アクセスするための fish shell 専用のプラグインです。  
次の特徴を持ちます。

+ パス情報(以降、DB とする)を使って高速に全ファイルシステムにアクセスする  
```
「ディレクトリ」であれば、cd を実行する
「ファイル」であれば、ファイル種別に応じてお気に入りのエディタやブラウザで開く
```
+ DB からファイルパスのみのコピー&ペーストも可能(X Windows が必要)
```
grep や cp, mv などでパスが必要となる場合の支援をする。
```
+ DB は cron, at 等のスケジューラ無しで自動更新する
```
初回のみ、ユーザによる手動による DB 構築が必要だが、最大限の並列探索により時間の短縮化をしている。
2回目以降(自動更新時)は、マシン負荷を減して DB を再構築する。(マシン負荷調整は可能である)
```
+ fishingz は root権限を使わないで実現しているので、所有 PC 以外でも使用可能   
```
必須ソフトは fzf であり、fzf は非管理者であってもローカル上に導入できる。  
推奨ソフトである xclip, xsel についてもローカル上に導入できる(はず)
```
+ Vim の Unite, Emacs の Anything のような操作性を持つ。 
++ 以下のように Unite に似た操作性となってい
```
C-u C-u ：「ディレクトリ」「ファイル」「シンボリックリンク」「履歴」全てを含む DB を使用する
C-u C-i ：「ディレクトリ」のみを含む DB を使用する。
C-u C-f ：「ファイル」のみを含む DB を使用する。
C-u C-l ：「シンボリックリンクファイル」のみを含む DB を使用する。
C-u C-m ：「履歴」のみを含む DB を使用する。
```
　
 
## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=デモ">
### $HOME/Videos から /etc/apache2/sites-enabled ディレクトリに移動する
#### :fish: 1　DB を開く
![open_a_locatedb](https://user-images.githubusercontent.com/39640214/41501398-9ff0be4e-71de-11e8-8720-41733d6c0f7e.gif)
　
#### :fish: 2　/etc/apache2/sites-enabled を選択する
fzf により絞り込みを行います。
![select_dir](https://user-images.githubusercontent.com/39640214/41502097-6ecb9834-71ed-11e8-804e-0cdfd8f8f102.gif)
　
 
## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=できること">
次の 2点 を行います。  

### :fish: 1　選択したパスに対してアクションを実行する
fzf ウィンドウに表示されたシステム全てのパスに対して以下のアクションを実行します。  
Unite (Vim) の Action に該当する部分です。
```diff
+ ディレクトリであれば cd を実行して移動する  
+ ファイルであれば 関連付けたエディタで開く  
+   - file -b -i の結果により関連付けが可能である   
-     (が、現状はコードに直書きする必要がある)
+ シンボリックリンクであれば、ディレクトリかファイルかを判別して上記いずれかの処理を行う  
+ パスをクリップボードにコピーする (X Windows ありの場合のみ)    
+   - Ctrl-e によるクリップボードへのコピーが可能である
-     (クリップボードへのコピー実施後のカーソル位置の(表示上の)復旧が未対応である)
```
　
### :fish: 2　パス収集を自動で行う    
ファイルシステム全体に対してパスの収集を行いファイルに出力します。  
Unite (Vim) の Source に該当する部分です。
パス収集については以下の留意点があります。
```diff
- 収集可能なパスはユーザがアクセス可能なパスに限定される  
- 初期設定では /proc, /tmp, /sys, /lib,... はパス収集の対象外としている  
- パス情報の収集作業は速度を優先してマシンスペックを最大限使う
- 初回のパス情報収集は手動で行う   
+ パス収集の2回目以降は自動的に収集される  
+ 自動更新のために cron, at などのタスクスケジューラを稼動させる必要はない
+ マシンスペックをフルに使うので、パス収集自体は速い
```
　
　
## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Install">

### :tropical_fish:　　Git を使ってインストールする
```console  
git clone https://nekochango@github.com/nekochango/fishingz  
cp -p ./fishingz/fishingz.fish $HOME/.config/fish/function/.  
```  
　
fishingz を使うためには以下のソフトが必要です。  
**必要なソフトウェア**
```diff
+ 　　　fish (2.7 以上を推奨する)
+ 　　　fzf  
+ 　　　tac
+ 　　　xclip もしくは xsel (必須ではないが、無ければ使用できない機能がある)
```  
　
 　
## <img src="http://placehold.jp/24/39aaff/ffffff/240x40.png?text=Setup">
### :tropical_fish:　1.　ショートカットキーと fishingz を関連付ける
以下の要領で Fish の fish_user_key_bindings.fish ファイルにキーバインディングを定義してください。  
　  
例) Ctrl-u Ctrl-u と fishingz コマンドを関連付ける場合  
　  
***$HOME/.config/fish/functions/fish_user_key_bindings.fish***  
　  
```diff
  function fish_user_key_bindings  
    ### fishingz ###  
+   bind \cu\cu 'fishingz' 

    fzf_key_bindings
    ### fzf ###
    if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
        bind \ct '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \ec '__fzf_cd'
        bind \eC '__fzf_cd --hidden'
(-- snip --)
```
　
　
### :tropical_fish:　2. パス情報ファイルを作成する
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


## <img src="http://placehold.jp/24/39aaff/ffffff/240x40.png?text=Demo">

### :blowfish: $HOME から /etc/apache2/sites-available/000-default.conf.d に移動する

fishingz は事前にファイルシステム全体のパス情報を取得しているので、ファイルシステムをまたいで移動することが可能である。  
今回の例ではディレクトリの移動であるが、ファイルやシンボリックリンクについても同じ要領で実行できる。  
　


|表示|C-u C-u を実行する<br>行頭[d]がディレクトリである。<br>行頭[H]がfishingzで直近実行したコマンドである。<br>色設定は fishingz.fish で定義しているので必要に応じて変える。|
|---|:--|
|　　|![fishingz_1](https://user-images.githubusercontent.com/39640214/41203061-26f782b4-6d0d-11e8-8db7-11613306e2bb.jpg)|

|抽出|fzf により絞り込みを行う<br>行頭[f]がファイルである。<br>行頭[l]がシンボリックリンクである。|
|---|:--|
|　　|![fishingz_1](https://user-images.githubusercontent.com/39640214/41202833-d7a26808-6d09-11e8-85a4-bcfc6effaaed.jpg)|

|決定|該当行で Enter キーを押下する。<br/>このときに今回実行したコマンドが次に [H]として表示される。|
|---|:--|
|　　|![fishingz_1 5](https://user-images.githubusercontent.com/39640214/41203287-ece6163c-6d0f-11e8-9d32-16581cf49c97.jpg)|

|完了後|次に C-u C-u を実行すると以下のように <b>[H]  cd /etc/apache2/sites-available/000-default.conf.d</b>が登録されている。|
|---|---|
||![fishingz_1 8](https://user-images.githubusercontent.com/39640214/41203500-d1005b32-6d12-11e8-93dd-20849ea3c6c7.png)|
　
 
### :cat2: Bug(1): 自動更新時にマシンパワーを使い過ぎているので下げる。
- 自動更新の契機は fishingz.fish の FISHINGZ_DB_REBUILD_THLD で定義している。
- 初期値は 50 。これは「fishingz を 50回実行したら自動更新を開始する」という意味である。
- パス情報収集のためにファイル探索を CPU個数 x 5 で実施しているが、自動更新時はパワーを落とすべき。

### :cat2: Bug(2): Ctrl-e でクリップボードにコピーした後にコマンドラインに戻るとカーソル位置が不正である。
- 行頭に戻っているように見えるが、実際は fishingz を呼び出す前の状態の位置にいる。
- 従って、ペーストすれば正しい位置に実行はできている。
- fzf で画面を切り替えてからコマンドラインに戻ったときに、元の位置に戻す方法がご存知の方がいましたら、お教えください。


