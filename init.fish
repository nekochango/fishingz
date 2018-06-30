#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Command to execute in case of [f]
# file-type : command : use sudo when readonly file : redirect : background 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g  FISHINGZ_F_ACTIONS  '
  "text/html"       : "setsid google-chrome" : ""     : "1>/dev/null 2>/dev/null" : "&"  
  "text/html"       : "setsid google-chrome" : "sudo" : "1>/dev/null 2>/dev/null" : "&"  
  "text/xml"        : "vi"                   : "sudo" : "1>/dev/null 2>/dev/null" : "&"  
  "text"            : "vi"                   : "sudo" : ""                        : ""   
  "image"           : "setsid xdg-open"      : ""     : "1>/dev/null 2>/dev/null" : "&"  
  "inode/x-empty"   : "vi"                   : ""     : ""                        : ""
'

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# No searchable top directories, when creating database
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g  FISHINGZ_EXCLUDE_FS   "/mnt"  "/srv"  "/lib"  "/lib64"  

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# No searchable directories, when creating database
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g FISHINGZ_EXCLUDE_DIR  ".mozilla"  ".cache"

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# It represents how many times fishingz is updated when it is updated
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g  FISHINGZ_DB_REBLD_THLD_C  50      # 50 reps           (Update DB when fishingz is used for a predetermined number of times)
set -g  FISHINGZ_DB_REBLD_THLD_T  86400   # 1day=3600(sec)*24 (Rebuild the DB when the predetermined time has elapsed)

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# the number of lines or commands that (a) are allowed in the history file 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g  FISHINGZ_HISTMAX          10000

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Number of Core to use when re-building DB
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g FISHINGZ_NPROC_ON_REBUILD  1

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# fzf color settings.
# 30:black, 31:red, 32:green, 33:yellow, 34:blue, 35:magenta, 36:cyan, 37:white 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g  FISHINGZ_COLOR_D  32m       # [d] directory
set -g  FISHINGZ_COLOR_F  36m       # [f] file
set -g  FISHINGZ_COLOR_L  35m       # [l] symlink
set -g  FISHINGZ_COLOR_H  33m       # [H] MRU
set -g  FISHINGZ_FZF_COLOR "--color=hl:#ff00b0,bg+:#666666"

