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

