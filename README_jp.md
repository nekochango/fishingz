## <img src="http://placehold.jp/28/39aaff/ffffff/180x40.png?text=fishingz">
fishingz は fzf を使った fish shell 専用のプラグインです。  
前提として fishingz は root権限を使わないことを想定して作成しています。  
　
　
　
## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=できること">
大別すると次の 2点 を行います。  

### :fish: 1　選択したパスに対してアクションを実行する
fzf ウィンドウに表示されたシステム全てのパスに対して以下のアクションを実行します。  
Vim の Unite, Emacs の Anything のようなイメージです。  

```diff
+ ディレクトリであれば cd を実行して移動する  
+ ファイルであれば 関連付けたエディタで開く  
+ パスをクリップボードにコピーする  
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
+ 　　　fish
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
　
　
### :tropical_fish:　2. PathDB を作成する
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
　
|||
|---|---|
|&#36;HOMEでC&#45;u C&#45;uを実行する|![fishingz_1](https://user-images.githubusercontent.com/39640214/41203061-26f782b4-6d0d-11e8-8db7-11613306e2bb.jpg)
|絞り込む|![fishingz_1](https://user-images.githubusercontent.com/39640214/41202833-d7a26808-6d09-11e8-85a4-bcfc6effaaed.jpg)||
|選択する|&#91;d&#93;  /etc/apache2/sites-available/000-default.conf.d |


