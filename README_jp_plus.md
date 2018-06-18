# fishingz の高度な設定

現状、$HOME/.fishingz/init.fish での設定変更は実装できておらず、ソースコードを直接変更する必要がある設定項目について記す。

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=___future___">
　

### :dolphin::dolphin:　　1.　探索対象外のファイルシステムを変更する


fishingz.fish 中の下記を変更すれば良い。
　

***$HOME/.config/fish/functions/fishingz.fish***
```
      # No searchable directories, when creating database
      set -g    FISHINGZ_EXCLUDE_FS         "/lost+found/" \
                                            "/snap/"       \
                                            "/proc/"       \
                                            "/sbin/"       \
                                            "/media/"      \
                                            "/root/"       \
                                            "/opt/"        \
                                            "/srv/"        \
                                            "/cdrom/"      \
                                            "/lib64/"      \
                                            "/mnt/"        \
                                            "/run/"        \
                                            "/tmp/"        \
                                            "/lib/"        \
                                            "/dev/"        \
                                            ""    # End of list
```  

　

### :dolphin::dolphin:　　2.　探索対象外のディレクトリを変更する


fishingz.fish 中の下記を変更すれば良い。(初期状態では、.git .cache .svn .CVS を探索対象外としている)
　

***$HOME/.config/fish/functions/fishingz.fish***
```
      set -g    FISHINGZ_EXCLUDE_DIR        "-o -name '.git'"     \
                                            "-o -name '.cache'"   \
                                            "-o -name '.svn'"     \
                                            "-o -name '.CVS'"     \
                                            ""    # End of list
```

　

### :dolphin::dolphin:　　3.　クリップボードへのパスのコピーを行うキーを変更する。


fishingz.fish 中の下記 ctrl-e を変更すれば良い。(詳細は fzf の --bind を参照)
　

***$HOME/.config/fish/functions/fishingz.fish***
```
        if test ( which xclip )
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint | fzf --no-sort $FISHINGZ_FZF_COLOR --ansi -d'\t' --nth 2 \
                                    --bind 'ctrl-e:execute-silent( echo -n {} | \
                                    sed -n "s/^\[[[:alpha:]]\]\(.*\)/\1/p" | xclip   ; tput rc )+abort' )
        else if test ( which xsel )
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint | fzf --no-sort $FISHINGZ_FZF_COLOR --ansi -d'\t' --nth 2 \
                                    --bind 'ctrl-e:execute-silent( echo -n {} | \
                                    sed -n "s/^\[[[:alpha:]]\]\(.*\)/\1/p" | xsel -i ; tput rc )+abort' )
        else
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint | fzf --no-sort --ansi -d'\t' --nth 2 )
        end
```

　

### :dolphin::dolphin:　　4.　ファイル種別に応じて使用するアプリを変更する。


fishingz.fish 中の下記 file -b -i の戻り値を分岐させて呼び出すアプリを定義すれば良い。
　

***$HOME/.config/fish/functions/fishingz.fish***
```diff
    function fishingz::command::opr_f --no-scope-shadowing \
    --description "When [f] is selected on the list"

      set -l  path  $argv[1]
      test ! -f $path ;and echo "$path: No such file" >&2
      set -l  ftype ( file -b -i $path )
  
      switch $ftype

        case "text/html*"
        
```
