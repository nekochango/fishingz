# <img src="http://placehold.jp/28/ffffff/ff0000/180x40.png?text=fishingz">
ファイルシステム全てに高速アクセスするための fish shell 専用のプラグイン。

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=特徴">
### :whale: パス情報(以降、DB とする)を使って高速に全ファイルシステムにアクセスする  
```diff
+ キーバインドにより DB をオープンして目的のパスを選択する。
+ パスの種類に応じて以下のように処理が自動的に選択される。
+　　- 選択したパスが「ディレクトリ」であれば、cd を実行する
+　　- HTML であれば Web ブラウザで開く
+　　- Text であれば お気に入りのエディタで開く
```

### :whale: DB からパスのみ取得する (X Windows が必要)
```diff
+ DB オープン中に Ctrl-e とすることで, カーソル下のパスを clipboard にコピーしてくれる
+ コピー後はコマンドラインに戻るので Shift-Insert などでペーストができる
+　　- これにより取得したパスを grep, cp, mv, diff, ls などの引数にできる
```

### :whale: DB 更新には cron, at 等のスケジューラは不要である
```diff
+ 一定回数だけ fishingz を使った操作をすれば DB の自動更新が行われる
+　　- DB 更新までの閾値は自由に設定可能である
+　　- DB 再構築時はバックグラウンドでマシン負荷を減らして行われる (負荷変更も可能)
+ DB 初回作成時のみ fishingz -i として手動実行が必要であるが、マシンスペックを最大限に使って DB を構築を高速に行う
```


## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=デモ">
### /etc/apache2/sites-enabled ディレクトリに移動する
#### :fish: 1　DB を開く
+ コマンドラインから C-u C-u と入力することで DB をオープンする。(キーは変更可能) 
![open_a_locatedb](https://user-images.githubusercontent.com/39640214/41501398-9ff0be4e-71de-11e8-8720-41733d6c0f7e.gif)

#### :fish: 2　/etc/apache2/sites-enabled を選択する
+ fzf により絞り込みが行われる。
+ 下図では /etcapac2site としてディレクトリを絞り込み、[d]  /etc/apache2/sites-enabled を選択している。
+ 以上の操作で cd /etc/apache2/sites-enabled が実行された。
![select_dir](https://user-images.githubusercontent.com/39640214/41502097-6ecb9834-71ed-11e8-804e-0cdfd8f8f102.gif)
　
 
