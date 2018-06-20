#!/usr/bin/env fish

function fishingz 

  function fishingz::load_userfile
    if test -f $HOME/.fishingz/init.fish
      source $HOME/.fishingz/init.fish
    end
  end

  function fishingz::load_settings \
  --description "The command written here is called in 'fishingz::stream::opr_f'."

    # command to call in the case of file
    test -z "$FISHINGZ_F_CMD"             ;and set -g FISHINGZ_F_CMD      "nano"
    # command to call in the case of HTML file
    test -z "$FISHINGZ_F_HTML_CMD"        ;and set -g FISHINGZ_F_HTML_CMD "firefox"
    # command to call in the case of directory
    test -z "$FISHINGZ_D_CMD"             ;and set -g FISHINGZ_D_CMD      "cd"
    # command to use in the background to call in the case of directory
#   test -z "$FISHINGZ_JORKER"            ;and set -g FISHINGZ_JORKER     "xdg-open"
    # use sudo, when you can not writ file (1:use sudo, 0: not use)
    test -z "$FISHINGZ_TOGGLE_USE_SUDO"   ;and set -g FISHINGZ_TOGGLE_USE_SUDO   0
    # execute it, if it have +x permission (1:execute,  0: not execute)
    test -z "$FISHINGZ_TOGGLE_EXEC_MODE"  ;and set -g FISHINGZ_TOGGLE_EXEC_MODE  0

    set -g    FISHINGZ_UUID                 (uuidgen)
    set -g    FISHINGZ_USER_AREA            /tmp/$USER.fishingz
    set -g    FISHINGZ_WORKDIR              $FISHINGZ_USER_AREA/$FISHINGZ_UUID
    set -g    FISHINGZ_AVATAR

  end   # End of 'fishingz::load_settings'


  function fishingz::DB --no-scope-shadowing 
    
    function fishingz::DB::load_settings

      # It represents how many times fishingz is updated when it is updated
      test -z "$FISHINGZ_DB_REBUILD_THLD" ;and set -g  FISHINGZ_DB_REBUILD_THLD  50
      test -z "$FISHINGZ_HISTSIZE"        ;and set -g  FISHINGZ_HISTSIZE         10

      # 30:black, 31:red, 32:green, 33:yellow, 34:blue, 35:magenta, 36:cyan, 37:white 
      test -z "$FISHINGZ_COLOR_D"   ;and  set -g  FISHINGZ_COLOR_D  32m       # [d] directory
      test -z "$FISHINGZ_COLOR_F"   ;and  set -g  FISHINGZ_COLOR_F  36m       # [f] file
      test -z "$FISHINGZ_COLOR_L"   ;and  set -g  FISHINGZ_COLOR_L  35m       # [l] symlink
      test -z "$FISHINGZ_COLOR_M"   ;and  set -g  FISHINGZ_COLOR_M  33m       # [M] MRU

      # fzf color option's
      test -z "$FISHINGZ_FZF_COLOR" ;and  set -g  FISHINGZ_FZF_COLOR "--color=hl:#ff00b0,bg+:#666666"

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
  
      set -g    FISHINGZ_EXCLUDE_DIR        "-o -name '.git'"     \
                                            "-o -name '.cache'"   \
                                            "-o -name '.svn'"     \
                                            "-o -name '.CVS'"     \
                                            ""    # End of list

      set -g    FISHINGZ_DB_PID            $FISHINGZ_UUID
      set -g    FISHINGZ_DB_TMPDIR         $FISHINGZ_WORKDIR
      set -g    FISHINGZ_DB_NAME           (basename (status -f))
      set -g    FISHINGZ_DB_MODE           "I"
  
      # define the output files that constitute the fishingz database.
      set -g    WALKED_DIRLIST              "$FISHINGZ_DB_TMPDIR/DIR/LIST/dirlist.txt" 
      set -g    WALKED_FILELIST             "$FISHINGZ_DB_TMPDIR/FILE/LIST/filelist.txt"
      set -g    WALKED_LINKLIST             "$FISHINGZ_DB_TMPDIR/LINK/LIST/linklist.txt"
      set -g    WALKED_ALL_LIST             "$WALKED_DIRLIST" "$WALKED_FILELIST" "$WALKED_LINKLIST"
  
      # file name database by fishingz
      set -g    FISHINGZ_DB_DIRNAME         $HOME/.fishingz
      set -g    FISHINGZ_DB_FILE            locate.db
      set -g    FISHINGZ_DB_PATH            $FISHINGZ_DB_DIRNAME/$FISHINGZ_DB_FILE
      set -g    FISHINGZ_DB_DIR_PATH        $FISHINGZ_DB_DIRNAME/d/fishingz_locate_d.db
      set -g    FISHINGZ_DB_FILE_PATH       $FISHINGZ_DB_DIRNAME/f/fishingz_locate_f.db
      set -g    FISHINGZ_DB_LINK_PATH       $FISHINGZ_DB_DIRNAME/l/fishingz_locate_l.db
      set -g    FISHINGZ_DB_MRU_PATH        $FISHINGZ_DB_DIRNAME/m/fishingz_locate_mru.db
      set -g    FISHINGZ_DB_CALLS           $FISHINGZ_DB_DIRNAME/.v/fishingz_calls.db
      set -g    FISHINGZ_DB_PATH_LIST       "$FISHINGZ_DB_PATH"      \
                                            "$FISHINGZ_DB_DIR_PATH"  \
                                            "$FISHINGZ_DB_FILE_PATH" \
                                            "$FISHINGZ_DB_LINK_PATH"
  
      set -g    FISHINGZ_DB_VERSION        1.7.0
      set -g    FISHINGZ_LOCKFILE          _____updating_____.lock
  
    end   # End of 'fishingz::DB::load_settings'
  
    function fishingz::DB::build \
    --description "execute find on directory, file and symbolic link" 
    
      set -g target
    
      function fishingz::DB::build::prepare \
      --description ""
        set   target            $argv
        # Delete elements written in $FISHINGZ_EXCLUDE_FS from $found_path
        for i in ( seq 1 (count $FISHINGZ_EXCLUDE_FS) )
          set -l omission ( echo $FISHINGZ_EXCLUDE_FS[$i] | sed 's|/$||g' )
          set    target   ( string replace -r "\A$omission\z" '' $target )
        end
      end   # End of function fishingz::DB::build::prepare
    
      function fishingz::DB::build::walkdir \
      --description "execute find on directory, file and symbolic link" 
    
        set -l visit_order       "dir"  "file"  "link"
    
        # walk directory according to the $WALKED_DIR_LIST
        for i in ( seq 1 ( count $WALKED_ALL_LIST ) )
          set -l d ( dirname $WALKED_ALL_LIST[$i] )
          rm -rf $d
          mkdir -p $d
    
          if test ( string match -r -i "dir" $visit_order[$i] )
            fishingz::DB::create_d_list $WALKED_DIRLIST $target
          else if test ( string match -r -i "file" $visit_order[$i] )
            fishingz::DB::create_f_and_l_list  "file"  $WALKED_DIRLIST $WALKED_ALL_LIST[$i]
          else if test ( string match -r -i "link" $visit_order[$i] )
            fishingz::DB::create_f_and_l_list  "link" $WALKED_DIRLIST $WALKED_ALL_LIST[$i]
          end
    
        end
      end   # End of fishingz::DB::build::walkdir
    
      function fishingz::DB::build::install
  
        if test $FISHINGZ_DB_MODE = "I" ;or test $FISHINGZ_DB_MODE = "R"

          rm -f $FISHINGZ_DB_DIR_PATH
          rm -f $FISHINGZ_DB_FILE_PATH
          rm -f $FISHINGZ_DB_LINK_PATH

          test -f $WALKED_DIRLIST  ;and cp -fp $WALKED_DIRLIST  $FISHINGZ_DB_DIR_PATH
          test -f $WALKED_FILELIST ;and cp -fp $WALKED_FILELIST $FISHINGZ_DB_FILE_PATH
          test -f $WALKED_LINKLIST ;and cp -fp $WALKED_LINKLIST $FISHINGZ_DB_LINK_PATH
  
          touch $FISHINGZ_DB_DIR_PATH
  
          # join 3 files
          test -f $FISHINGZ_DB_DIR_PATH  ;
          and sed "s|.*|[1;$FISHINGZ_COLOR_D\[d\]\t&[0m|g" $FISHINGZ_DB_DIR_PATH  >> $FISHINGZ_DB_TMPDIR/$FISHINGZ_DB_FILE
    
          test -f $FISHINGZ_DB_FILE_PATH ;
          and sed "s|.*|[1;$FISHINGZ_COLOR_F\[f\]\t&[0m|g" $FISHINGZ_DB_FILE_PATH >> $FISHINGZ_DB_TMPDIR/$FISHINGZ_DB_FILE
    
          test -f $FISHINGZ_DB_LINK_PATH ;
          and sed "s|.*|[1;$FISHINGZ_COLOR_L\[l\]\t&[0m|g" $FISHINGZ_DB_LINK_PATH >> $FISHINGZ_DB_TMPDIR/$FISHINGZ_DB_FILE
    
          # replace database file
          cp -fp $FISHINGZ_DB_TMPDIR/$FISHINGZ_DB_FILE $FISHINGZ_DB_DIRNAME/$FISHINGZ_DB_FILE
        end
      end   # End of fishingz::DB::build::install
  
      fishingz::DB::build::prepare  $argv
      fishingz::DB::build::walkdir
      fishingz::DB::build::install
      
    end   # end of function fishingz::DB::build \


    function fishingz::DB::get_path --no-scope-shadowing
  
      function fishingz::DB::get_path::sort \
      --description "Rearrange based on character string"
  
        set -l index  $argv[1]
        set -l filter
        set -l database
        set -l color
        set -l M 

        if test -z "$argv[3]"
          set   filter    ""
        else if test ! -z "$argv[3]" 
          set   filter    $argv[3]
        end

        if test -z "$filter"
          # Display all types
          set database  $FISHINGZ_DB_PATH
          set M ( egrep -n "\[d\]	$index\[0m" $database | cut -f1 -d':' )
          if test ! -z $FISHINGZ_HISTSIZE
            tail -n $FISHINGZ_HISTSIZE $FISHINGZ_DB_MRU_PATH | tac | \
              sed  "s|\(.*\)|[1;$FISHINGZ_COLOR_M\[M]	&[0m|g" 
          end

          if test -z "$M"
            # I am in a location that is not registered in the DB
            cat $database
          else if test "$M" -eq 1
            cat $database
          else if test "$M" -eq 2
            sed -n '2,$'p $database  
            sed -n 1p     $database  
          else
            set  B      ( expr $M - 1 ) # before from $M
            sed -n "$M,\$"p  $database 
            sed -n "1,$B"p   $database | tac
          end

        else  # test "$filter"
          # Individually display
          if test $filter = "--find-dir"
            set database  $FISHINGZ_DB_DIR_PATH
            test $argv[4] = "--ansi" ;and set color  $FISHINGZ_COLOR_D
            set M ( grep -n -w "$index" $database | head -n1 | cut -f1 -d':' )
          else if test $filter = "--find-file"
            set database  $FISHINGZ_DB_FILE_PATH
            test $argv[4] = "--ansi" ;and set color  $FISHINGZ_COLOR_F
            set M ( grep -n -w "$index" $database | head -n1 | cut -f1 -d':' )
          else if test $filter = "--find-link"
            set database  $FISHINGZ_DB_LINK_PATH
            test $argv[4] = "--ansi" ;and set color  $FISHINGZ_COLOR_L
            set M ( grep -n -w "$index" $database | head -n1 | cut -f1 -d':' )
          else if test $filter = "--find-mru"
            set database  $FISHINGZ_DB_MRU_PATH
            test $argv[4] = "--ansi" ;and set color  $FISHINGZ_COLOR_M
          end

          if test -z "$M" ;and test $filter = "--find-mru"
            test ! -z "$color" ;and sed "s|.*|[1;$color&[0m|g" $database | tac
                               ;or  tac $database 
          else if test -z "$M"
            # I am in a location that is not registered in the DB
            test ! -z "$color" ;and sed "s|.*|[1;$color&[0m|g" $database 
                               ;or  cat $database
          else if test "$M" -eq 1
            test ! -z "$color" ;and sed "s|.*|[1;$color&[0m|g" $database 
                               ;or  cat $database
          else if test "$M" -eq 2
            if test ! -z "$color"
              sed -n '2,$'p $database | sed "s|.*|[1;$color&[0m|g"       
              sed -n 1p     $database | sed "s|.*|[1;$color&[0m|g" | tac 
            else
              sed -n '2,$'p $database  
              sed -n 1p     $database  
            end
          else
            if test ! -z "$color"
              set  B      ( expr $M - 1 ) # before from $M
              sed -n "$M,\$"p $database | sed "s|.*|[1;$color&[0m|g"
              sed -n "1,$B"p  $database | sed "s|.*|[1;$color&[0m|g" | tac
            else
              set  B      ( expr $M - 1 ) # before from $M
              sed -n "$M,\$"p  $database
              sed -n "1,$B"p   $database | tac
            end
          end
        end

      end   # End of fishingz::DB::get_path::sort
  
      set -l  basepoint (pwd)

      if test -z "$argv[3]"
        tput sc
        if test ( which xclip )
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint | fzf --no-sort $FISHINGZ_FZF_COLOR --ansi -d'\t' --nth 2 \
                                    --bind 'ctrl-e:execute-silent( echo -n {} | \
                                    sed -n "s|^\[[[:alpha:]]\]\(.*\)|\1|p" | xclip   ; tput rc )+abort' )
        else if test ( which xsel )
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint | fzf --no-sort $FISHINGZ_FZF_COLOR --ansi -d'\t' --nth 2 \
                                    --bind 'ctrl-e:execute-silent( echo -n {} | \
                                    sed -n "s|^\[[[:alpha:]]\]\(.*\)|\1|p" | xsel -i ; tput rc )+abort' )
        else
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint | fzf --no-sort --ansi -d'\t' --nth 2 )
        end
      else
        if test ( which xclip )
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint $argv | fzf --no-sort $FISHINGZ_FZF_COLOR --ansi \
                                    --bind 'ctrl-e:execute-silent( echo -n {} | xclip )+abort' )
        else if test ( which xsel )
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint $argv | fzf --no-sort $FISHINGZ_FZF_COLOR --ansi \
                                    --bind 'ctrl-e:execute-silent( echo -n {} | xsel -i )+abort' )
        else
          set ptr_RETURNED_PATH ( fishingz::DB::get_path::sort $basepoint | fzf --no-sort --ansi )
        end
      end
  
      test ! -z "$tmpf" ;and rm -f $tmpf
  
      #set ptr_RETURNED_PATH ( xclip -o | tr '\t' ' ' )
    end   # End of function fishingz::DB::get_path
  
  
    function fishingz::DB::auto_rebuild \
    --description "When the threshold is exceeded, the database is updated." \
    --description "This threshold is held in $FISHINGZ_DB_REBUILD_THLD."

      # If there is no threshold or 0.
      if test -z "$FISHINGZ_DB_REBUILD_THLD" ;or test "$FISHINGZ_DB_REBUILD_THLD" = 0
        rm -f $FISHINGZ_AVATAR
        return 0
      end

      echo (date "+%s") >> $FISHINGZ_DB_CALLS
      set -l cur ( cat $FISHINGZ_DB_CALLS 2>/dev/null | wc -l )
      set -l mod ( echo "$cur % $FISHINGZ_DB_REBUILD_THLD" | bc )
  
      if test $mod -eq 0
        rm -f $FISHINGZ_DB_CALLS
        # Create a lock file so that it will not be executed multiple times
        set -g FISHINGZ_AVATAR_MODE "ON"
        setsid nice -n 20 fish $FISHINGZ_AVATAR -R &
      else
        rm -f $FISHINGZ_AVATAR
      end
    end
  
    function fishingz::DB::add_mru \
    --description "record the command executed with fishingz" 
  
      test ! -f $FISHINGZ_DB_MRU_PATH ;and touch $FISHINGZ_DB_MRU_PATH
  
      if test -z "$argv" 
        return 1
      end
  
      if test ! -z "$argv" 
        test ! -f $FISHINGZ_DB_MRU_PATH ;and touch $FISHINGZ_DB_MRU_PATH 
  
        set -l ret ( sed -n "\|^$argv\$|p" $FISHINGZ_DB_MRU_PATH )
        if test ! -z "$ret"
          sed -i "\|^$argv|d"  $FISHINGZ_DB_MRU_PATH
        end
      end
  
      echo "$argv" >> $FISHINGZ_DB_MRU_PATH
      return 0
    end
  
    function fishingz::DB::create_d_list \
    --description "execute find directory" 
    
      set -l script     "$FISHINGZ_DB_TMPDIR/find_d.fish"
      set -l output     $argv[1]
      set -l omission   $FISHINGZ_EXCLUDE_DIR
    
      test -z "$output" ;and echo '$output is NULL at '(status function) >&2 ;and exit 2
    
      # set internal parameters and directories
      set -l workdir    "$FISHINGZ_DB_TMPDIR/DIR/PARTS"
      test ! -d "$workdir" ;and mkdir -p $workdir
    
      # prepare for executing 'find' in parallel
      echo  "set -l num 0"                                                  >> $script
      echo  "set -l i   0"                                                  >> $script
      echo  "for arg in $argv[2..-1]"                                       >> $script
      echo  "  set i ( expr 1 + \$i )"                                      >> $script
      echo  "  # run 'find' by parallel thread"                             >> $script
      echo  "  echo \$arg | xargs -I@ find @ \\( -type d 2>/dev/null \\"    >> $script
      echo  "    -and \\( -name '' $omission \\) -prune \\) \\"             >> $script
      echo  "    -or \\( -type d -and -print \\) > $workdir/\$i   &"        >> $script
      echo  "end"                                                           >> $script
      echo  "# wait for the job to finish"                                  >> $script
      echo  "while true"                                                    >> $script
      echo  "  set -l bg_jobs ( builtin jobs -p 2>/dev/null )"              >> $script
      echo  "  test -z \"\$bg_jobs\" ;and break"                            >> $script
      echo  "  sleep 0.5"                                                   >> $script
      echo  "  set num ( cat $workdir/* 2>/dev/null | wc -l )"              >> $script
      echo  "  echo -en \"Searching directories ... [\$num]\"\"\\r\""       >> $script
      echo  "end"                                                           >> $script
      echo  ""                                                              >> $script
      echo  "# join the file"                                               >> $script
      echo  "cat $workdir/* > $output"                                      >> $script
      echo  "set num ( cat $workdir/* 2>/dev/null | wc -l )"                >> $script
      echo  "echo \"Searching directories ... [\$num]\""                    >> $script
      echo  ""                                                              >> $script
    
      if test "$FISHINGZ_ECHO_OFF" = 1
        fish $script > /dev/null
      else
        fish $script 
      end
    end   # End of 'fishingz::DB::create_d_list'
    
    function fishingz::DB::create_f_and_l_list \
    --description "execute find file or link on directory"
    
      # select search file that real file or symlink
      if test ( string match -r -i "\A[l|L]" "$argv[1]" )
        set t     "l"
        set type  "LINK"  
        set mesg  "symbolic links"
        set c     "35"
      else if test ( string match -r -i "\A[f|F]" "$argv[1]" )
        set t     "f"
        set type  "FILE"  
        set mesg  "files"
        set c     "34"
      else
        echo "$argv[1]: invalid argument"(status function) >&2
      end
    
      set -l input        $argv[2]
      set -l output       $argv[3]
      set -l sum          ( egrep -c "*" $input )   # num of directories 
      if test ! -z "$FISHINGZ_NPROC_ON_REBUILD" ;and test "$FISHINGZ_DB_MODE" = "R"
        if test "$FISHINGZ_NPROC_ON_REBUILD" = "0"
          set  cores        1
          set  thread       1
        else
          set  cores        ( expr $FISHINGZ_NPROC_ON_REBUILD )
          set  thread       $cores
        end
      else
        set    cores        ( nproc )
        set    thread       ( echo "$cores"' * 5' | bc )
      end
      set -l sep          ( expr $sum /  $thread )  # one thread has lines
      set -l mod          ( expr $sum \% $thread )
      set -l b            1                         # Begin (counter)
      set -l e            $sep                      # End   (counter)
      set -l script       "$FISHINGZ_DB_TMPDIR/find_$t.fish"
      set -l script_chld
     
      set -l workdir  "$FISHINGZ_DB_TMPDIR/$type/PARTS"
      test ! -d "$workdir" ;and mkdir -p $workdir
    
      for i in ( seq 1 $thread )
        # child script name setting
        set script_chld  "$FISHINGZ_DB_TMPDIR/$type/find_$t.$i.fish"
     
        # write in process tha execute find -f
        cat   $input | sed -n "$b,$e s|.*|find \"&\" -maxdepth 1 -type $t 2>/dev/null >> $workdir/$b.$e.list|p" > $script_chld
     
        set b ( expr $e + 1    )  # begin line
        set e ( expr $b + $sep )  # end line
        test $i -eq $thread ;and set e ( expr $e + $mod ) # if last thread, $e + modulo
      end
    
      echo "set -l num 0"                                                   >> $script
      echo "# prepare for executing 'find' in parallel"                     >> $script
      echo "for i in ( seq 1 $thread )"                                     >> $script
      echo "  set script_chld  $FISHINGZ_DB_TMPDIR/$type/find_$t.\$i.fish" >> $script
      echo "  # run 'find' by parallel thread"                              >> $script
      echo "  fish \$script_chld &"                                         >> $script
      echo "end"                                                            >> $script
      echo ""                                                               >> $script
      echo "# wait for the job to finish"                                   >> $script
      echo "while true"                                                     >> $script
      echo "  set -l bg_jobs ( builtin jobs -p 2>/dev/null )"               >> $script
      echo "  test -z \"\$bg_jobs\" ;and break"                             >> $script
      echo "  sleep 0.5"                                                    >> $script
      echo "  echo -en \"Searching $mesg .     \"\"\\r\""                   >> $script
      echo "  sleep 0.5"                                                    >> $script
      echo "  echo -en \"Searching $mesg ..    \"\"\\r\""                   >> $script
      echo "  sleep 0.5"                                                    >> $script
      echo "  echo -en \"Searching $mesg ...   \"\"\\r\""                   >> $script
      echo "  sleep 0.5"                                                    >> $script
      echo "  set num ( cat $workdir/* 2>/dev/null | wc -l )"               >> $script
      echo "  echo -en \"Searching $mesg ....  [\$num]\"\"\\r\""            >> $script
      echo "end"                                                            >> $script
      echo ""                                                               >> $script
      echo "cat $workdir/( find $workdir/. -maxdepth 1 -type f | \\"        >> $script
      echo "  xargs -I@ basename @ | sort -n ) > $output"                   >> $script
      echo "set num ( cat $workdir/* 2>/dev/null | wc -l )"                 >> $script
      echo "echo \"Searching $mesg ....  [\$num]\""                         >> $script
      echo ""                                                               >> $script
     
      if test "$FISHINGZ_ECHO_OFF" = 1
        fish $script > /dev/null
      else
        fish $script
      end
    end   # End of 'fishingz::DB::create_f_and_l_list'
    
    function fishingz::DB::pipeline --no-scope-shadowing
  
      function fishingz::DB::pipeline::init
  
        fishingz::DB::load_settings
  
        # mkdir database directory
        for i in ( seq 1 ( count $FISHINGZ_DB_PATH_LIST ) )
          set -l dname ( dirname $FISHINGZ_DB_PATH_LIST[$i] ) 
          test ! -d $dname ;and mkdir -p $dname
        end
  
        # mkdir mru's directory
        test ! -d (dirname $FISHINGZ_DB_MRU_PATH) ;
          and mkdir -p (dirname $FISHINGZ_DB_MRU_PATH)
        touch $FISHINGZ_DB_MRU_PATH
  
        # mmkdir the directory that stores thresholds used for automatic update or judgment.
        test ! -d (dirname $FISHINGZ_DB_CALLS) ;
          and mkdir -p (dirname $FISHINGZ_DB_CALLS)

      end   # fishingz::DB::pipeline::init

      
      function fishingz::DB::pipeline::setup
  
        test ! -d "$FISHINGZ_DB_TMPDIR" ;and mkdir -p $FISHINGZ_DB_TMPDIR
  
        if test -z "$argv[1]" 
          echo "option is nothing.." >&2
        else if test $argv[1] = "-i"  ;or test $argv[1] = "-R"
#         rm -f $FISHINGZ_DB_DIR_PATH
#         rm -f $FISHINGZ_DB_FILE_PATH
#         rm -f $FISHINGZ_DB_LINK_PATH
#         #rm -f $FISHINGZ_DB_MRU_PATH
          test $argv[1] = "-i" ;and set FISHINGZ_DB_MODE "I"
                               ;or  set FISHINGZ_DB_MODE "R"
        else if test $argv[1] = "--get-path"
          set FISHINGZ_DB_MODE "G"
        else if test $argv[1] = "--save-mru"
          set FISHINGZ_DB_MODE "M"
        else
          echo "$argv[1] was Invalid option" >&2
        end
      end   # End of fishingz::DB::pipeline::setup
  
      function fishingz::DB::pipeline::start --no-scope-shadowing \
      --description "create new databese, or update existing database"
  
        set -l target 
        set -l mesg $argv[2..-1]
  
        if test "$FISHINGZ_DB_MODE" = "I" ;or test "$FISHINGZ_DB_MODE" = "R" 
          set -l  found_path  ( find / -maxdepth 1 -mindepth 1 -type d 2>/dev/null )
          set     target      $found_path # copy for debug 
          test -z "$target" ;and echo "$mesg was out of creating"  >&2
          if test -f "$FISHINGZ_USER_AREA/$FISHINGZ_LOCKFILE" ;and test "$FISHINGZ_DB_MODE" = "R" 
            return 1  # don't remove $FISHINGZ_WORKDIR
          else
            touch $FISHINGZ_USER_AREA/$FISHINGZ_LOCKFILE  # Lock to prevent multiple execution
            fishingz::DB::build $target
            rm -f $FISHINGZ_USER_AREA/$FISHINGZ_LOCKFILE  # Unlock
          end
        else if test "$FISHINGZ_DB_MODE" = "G"
          fishingz::DB::get_path $argv
  
        else if test "$FISHINGZ_DB_MODE" = "M"
          fishingz::DB::add_mru  $argv[3..-1] 
          set retval $status
          if test $retval -eq 0
            if test -f "$FISHINGZ_USER_AREA/$FISHINGZ_LOCKFILE"
              return 1  # don't remove $FISHINGZ_WORKDIR
            else
              fishingz::DB::auto_rebuild
            end
          end
        end
      end   # End of fishingz::DB::pipeline::start
  
      function fishingz::DB::pipeline::stop
      end
  
      # routine start
      fishingz::DB::pipeline::init  $argv
      fishingz::DB::pipeline::setup $argv
      fishingz::DB::pipeline::start $argv
      fishingz::DB::pipeline::stop  $argv
  
    end   # End of 'fishingz::DB::pipeline'
  
    switch $argv[1]
      case  "-i"    # accessed accessed by 'fishingz_update'
       fishingz::DB::pipeline $argv
      case  "-R"    # accessed accessed by 'fishingz_update'
       fishingz::DB::pipeline $argv
      case  "-m"    # Update mru data
        fishingz::DB::pipeline --save-mru $argv
      case  "-g"    # Get path accessed by 'fishingz'
        fishingz::DB::pipeline --get-path $argv[2..-1]
    end
  
  end   # End of 'fishingz::DB '


  function fishingz::command --no-scope-shadowing
  
    set -l SUDO

    test ( string match -r -i "\A[t|e|1]" "$FISHINGZ_TOGGLE_USE_SUDO" ) ;
      and set SUDO "sudo"

    function fishingz::command::opr_d --no-scope-shadowing \
    --description "When [d] is selected on the list"

      set -l  path  $argv[1]

      if test -z "$path"
        return 0
      else if test ! -x "$path"
        echo "$path: could not access"
        ls -ld $path
        return 0
      else
        eval $FISHINGZ_D_CMD $path
        set ptr_EXECLINE "$FISHINGZ_D_CMD $path"
      end
    end # End of 'fishingz::command::opr_d'
  

    function fishingz::command::opr_f --no-scope-shadowing \
    --description "When [f] is selected on the list"

      set -l  path  $argv[1]
      test ! -f $path ;and echo "$path: No such file" >&2
      set -l  ftype ( file -b -i $path )
  
      switch $ftype

        case "text/html*"
          if test ! -z "$FISHINGZ_F_HTML_CMD"
            set ptr_EXECLINE "$FISHINGZ_F_CMD $path"
            eval $FISHINGZ_F_CMD $path ;
          else if test ( which $FISHINGZ_F_HTML_CMD )
            set ptr_EXECLINE "setsid $FISHINGZ_F_HTML_CMD $path 2>/dev/null &"
            setsid $FISHINGZ_F_HTML_CMD $path 2>/dev/null &
          else
            set ptr_EXECLINE "$FISHINGZ_F_CMD $path"
            eval $FISHINGZ_F_CMD $path ;
          end
        case "text/*"
          if test -w $path 
            eval $FISHINGZ_F_CMD $path ;
            set ptr_EXECLINE "$FISHINGZ_F_CMD $path"
          else
            eval $SUDO $FISHINGZ_F_CMD $path
            set ptr_EXECLINE "$SUDO $FISHINGZ_F_CMD $path"
          end
  
        case "application/x-executable*charset=binary"  # binary file
          if test ( string match -r -i "\A[t|e|1]" "$FISHINGZ_TOGGLE_EXEC_MODE" )
            eval builtin string ' ' "fish" "-c" "$path" 
            set ptr_EXECLINE "fish -c $path"
          else
            echo 'executable mode off' >&2
          end
  
        case "application/x-sharedlib"
            echo "Sorry, could not open $path"

        case "*x-empty*"  # empty file
          echo "$path: empty file..." >&2
  
        case "*"
          if test ! -z "$FISHINGZ_JORKER"
            eval $FISHINGZ_JORKER $path 
            set ptr_EXECLINE "$FISHINGZ_JORKER $path"
          else
            echo "$path: no action" >&2
          end
      end 
    end  # End of 'fishingz::command::opr_f'
  

    function fishingz::command::opr_l  --no-scope-shadowing\
    --description "When [l] is selected on the list" \
    --description "In the case of a symbolic link, judge the file type and open it"
  
      set -l  path  (realpath $argv[1] )    # absolute path without symlink
  
      if test -d $path
        fishingz::command::opr_d $path
      else if test -f $apach 
        fishingz::command::opr_f $path
      else
        echo "$path: could not access" >&2
      end
    end  # End of 'fishingz::command::opr_l'
  

    function fishingz::command::opr_m --no-scope-shadowing\
    --description "When [M] is selected on the list" \
    --description "In the case of a symbolic link, judge the file type and open it"
      eval $argv
      set ptr_EXECLINE "$argv"
    end


    set -l type   $argv[1]
    set -l path   $argv[2]
  
    switch "$type"
      case "[d]"
        fishingz::command::opr_d  $path
      case "[f]" 
        fishingz::command::opr_f  $path
      case "[l]"
        fishingz::command::opr_l  $path
      case "[M]"
        fishingz::command::opr_m  $path
      case ""
        #echo '$type was empty...' >&2
      case "*"
        echo "$type: No such type" >&2
    end
  end   # End of fishingz::command


  function fishingz::make_avatar \
  --description "I duplicate myself and call myself on the background to re-build database." \
  --description "Because I do not know the location of the executable file (fishingz.fish)." \
  --description "fishscript can duplicate the function of the location by 'functions'. "

    test ! -d $FISHINGZ_WORKDIR ;and mkdir -p $FISHINGZ_WORKDIR
    set    FISHINGZ_AVATAR   ( mktemp -p $FISHINGZ_WORKDIR )
    functions fishingz      >> $FISHINGZ_AVATAR
    sed -i '1s|^|set   -g  FISHINGZ_ECHO_OFF 1\n|'        $FISHINGZ_AVATAR
    sed -i '1s|^|set   -g  FISHINGZ_AVATAR   (mktemp)\n|' $FISHINGZ_AVATAR
    sed -i '$a fishingz $argv' $FISHINGZ_AVATAR
  end


  function fishingz::verify_settings

    test -z "$FISHINGZ_TOGGLE_USE_SUDO" ;
      and set FISHINGZ_TOGGLE_USE_SUDO 0

    test -z "$FISHINGZ_F_CMD" ;
      and echo 'Error: $FISHINGZ_F_CMD is empty'    >&2 ;and exit 2

    test -z "$FISHINGZ_D_CMD" ;
      and echo 'Error: $FISHINGZ_D_CMD is empty'    >&2 ;and exit 2

    test -z "$FISHINGZ_WORKDIR" ;
      and echo 'Error: $FISHINGZ_WORKDIR is empty'  >&2 ;and exit 2

    test -z "$FISHINGZ_USER_AREA" ;
      and echo 'Error: $FISHINGZ_USER_AREA is empty'>&2 ;and exit 2

  end


  function fishingz::stream
    set -l ptr_EXECLINE
  
    function fishingz::stream::init
      fishingz::load_userfile
      fishingz::load_settings
      fishingz::verify_settings
    end
    
    function fishingz::stream::setup
      fishingz::make_avatar
    end
    
    function fishingz::stream::start --no-scope-shadowing 
      set -l type
      set -l path
      set -l ptr_RETURNED_PATH
    
      fishingz::DB -g $argv

      if test ! -z "$ptr_RETURNED_PATH"
        if test -z "$argv[1]"
          set type   ( echo $ptr_RETURNED_PATH | cut -f1  -d'	')
          set path   ( echo $ptr_RETURNED_PATH | cut -f2- -d'	')
        else
          test "$argv[1]" = "--find-dir"  ;and set type "[d]"
          test "$argv[1]" = "--find-file" ;and set type "[f]"
          test "$argv[1]" = "--find-link" ;and set type "[l]"
          test "$argv[1]" = "--find-mru"  ;and set type "[M]"
          set path   ( echo $ptr_RETURNED_PATH )
        end
        fishingz::command $type $path
      end
    end
    
    function fishingz::stream::stop

      test ! -z "$argv" ;and fishingz::DB -m "$argv"
      test   -z "$FISHINGZ_USER_AREA" ;and echo 'Error: $FISHINGZ_USER_AREA is empty' ;and return 255
      if test ! -f $FISHINGZ_USER_AREA/$FISHINGZ_LOCKFILE ;and test -z "$FISHINGZ_AVATAR_MODE"
        rm -rf $FISHINGZ_USER_AREA/*
      end
    end
  
    if test "$argv" = '--init-only'
      fishingz::stream::init $argv
    else if test "$argv" = "--stop-only"
      fishingz::stream::stop
    else
      # initializing on fishingz
      fishingz::stream::init  $argv
      fishingz::stream::setup $argv
      fishingz::stream::start $argv
      fishingz::stream::stop  $ptr_EXECLINE
    end

  end   # End of 'function fishingz::stream'

  if test -z "$argv[1]"
    fishingz::stream
  else if   test "$argv[1]" = "--find-dir"  ;
         or test "$argv[1]" = "--find-file" ;
         or test "$argv[1]" = "--find-link" ;
         or test "$argv[1]" = "--find-mru"
    fishingz::stream $argv[1] --ansi
  else if test $argv[1] = "-i" ;or test $argv[1] = "-R"
    fishingz::stream --init-only
    fishingz::DB $argv
    fishingz::stream --stop-only
  end

end   # End of 'func fishingz'

#fishingz $argv
#func_updatedb $argv
