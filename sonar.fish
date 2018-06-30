function sonar \
--description "locate the file or directory name from DB for fishingz"

  functions fishingz 2>/dev/null 1>/dev/null
  set -l retval $status

  if test $retval -ne 0
    echo 'Error: Could not found "fishingz".'
    return 127
  end

  fishingz -l 

  if test ! -z "$FISHINGZ_DB_FILES"
    for i in ( seq 1 ( count $FISHINGZ_DB_FILES ) )
      egrep $argv $FISHINGZ_DB_FILES[$i]
    end
  end

end

