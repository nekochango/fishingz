# <img src="http://placehold.jp/32/39aaff/000000/180x40.png?text=fishingz">
A plugin dedicated to fish shell for fast access to all file systems.  
Access is made based on path information collected in advance (hereinafter referred to as DB).

　

## <img src="http://placehold.jp/32/39aaff/444444/180x40.png?text=contents">
<b><a href="#-2">Features</a></b><br/>
<b><a href="#-3">Demo(1)</a></b><br/>
<b><a href="#-4">Demo(2)</a></b><br/>
<b><a href="#-5">Demo(3)</a></b><br/>
<b><a href="#-6">Install</a></b><br/>
<b><a href="#-7">Setup</a></b><br/>
<b><a href="#-8">Advanced Settings</a></b><br/>

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Features">
### :whale: High-speed access using DB
```diff
+ Open the DB and select the target path.
+　　- Do not identify path (find command execution) every access
+ The process is automatically executed as follows depending on the type of the selected path.
+　　- If it is "directory", execute cd
+　　- If it is HTML, it opens in the web browser
+　　- If it is Text, it will be opened with your favorite editor
```

### :whale: Acquire pass only from DB
```diff
+ Ctrl-k will copy the path under the cursor to the clipboard
+ After copying it returns to the command line so you can paste with Shift - Insert etc.
+　　- The path obtained by this can be an argument such as grep, cp, mv, diff, ls
```

### :whale: Initial DB construction applied high speed correspondence
```diff
+ DB Collect file paths using machine specifications as much as possible only when it is first constructed.
```

### :whale: Automatic DB update after the second time
```diff
+ Use fishingz for a certain number of times, or automatic update is performed when a certain time has passed since immediately after DB construction
+　　- The threshold up to DB update can be set freely
+　　- When rebuilding the DB, it is done with the machine load reduced in the background (load change is also possible)
+　　- Scheduler registration such as cron, at etc. is unnecessary because the update opportunity is simple
```

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Demo(1)">
### Move to the / etc / apache2 / sites-enabled directory
#### :fish: 1　Open DB
+ Open the DB by entering C - u C - u from the command line. (Key can be changed)   
![open_a_locatedb](https://user-images.githubusercontent.com/39640214/41501398-9ff0be4e-71de-11e8-8720-41733d6c0f7e.gif)

#### :fish: 2　Select a path
+ We narrow down as / etcapac2site by fzf.    
+ Select the target <b> [d] / etc / apache 2 / sites - enabled </ b>.    
+ <B> cd / etc / apache 2 / sites-enabled </ b> was executed with the above operation  
![select_dir](https://user-images.githubusercontent.com/39640214/41502097-6ecb9834-71ed-11e8-804e-0cdfd8f8f102.gif)

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Demo(2)">
### Open /home/neko/.local/share/fish/generate_completions/fzf-tmux.fish with nvim-qt
#### :fish: 1　Open DB for file
+ Open the file DB by entering C - u C - f from the command line. (Key can be changed)

#### :fish: 2　Select a path
+ Filter by fzf as fishfzf.fish.
+ Select the target <b> /home/neko/.local/share/fish/generate_completions/fzf-tmux.fish </ b>.  
![demo_f](https://user-images.githubusercontent.com/39640214/41606895-b448e1da-741f-11e8-9388-0b3b85ba016d.gif)

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Demo(3)">
### Copy only path information from DB with Ctrl-k
#### :fish: 1　Open DB for file
+ Open Directory for DB by entering C-u C-i from the command line. (Key can be changed) 

#### :fish: 2　Select a path
+ Move the cursor to / etc / systemd
+ Press Ctrl-k to copy / etc / systemd to clipboard (key can be changed)
+ Paste to the console with Shift-Insert
![ctrlk](https://user-images.githubusercontent.com/39640214/41803236-c112332c-76c1-11e8-920a-c986c656e75a.gif)


　


## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Install">

### :tropical_fish:　　Required Software
```diff
+ 　　　fish (Over ver2.7)
+ 　　　fzf  
+ 　　　xclip Or xsel
```  

### :tropical_fish:　　1.　Install fishingz
<b>by GitHub</b>
```console  
git clone https://github.com/nekochango/fishingz  
cp -p ./fishingz/fishingz.fish $HOME/.config/fish/function/.  
```
```console
source $HOME/.config/fish/functions/fishingz.fish
```

<b>by fisherman</b>
```console  
fisherman nekochango/fishingz
```
```console
source $HOME/.config/fish/functions/fishingz.fish
```

### :tropical_fish:　　2.　Install fzf
- [fzf　:mag:](https://github.com/junegunn/fzf#using-git)
```console
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### :tropical_fish:　　3.　Install xclip
- [xclip　:mag:](https://github.com/astrand/xclip)  

If there is no administrator authority, compile and create xclip.
```console
git clone https://github.com/astrand/xclip
autoreconf		# create configuration files
./configure		# create the Makefile
make			# build the binary
```

If you have administrator privileges, install with 
apt-get install </ b>. 
```console
apt-get install -y xclip
```

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Setup">


### :tropical_fish:　　1.　Make key binding to call fishingz

|Key|Corresponding command|processing Contents|
|---|---|:--|
|C-u C-u|fishingz|Use a DB containing "directory", "file", "symbolic link", "history" all.|
|C-u C-i|fishingz --find-dir|Use a DB containing only "directory".|
|C-u C-f|fishingz --find-file|Use a DB containing only "file".|
|C-u C-l|fishingz --find-link|Use a DB containing only "symbolic link file".|
|C-u C-m|fishingz --find-mru|Use a DB containing only "history".|

　

When setting the above table, please describe as follows. 
　

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

　

### :tropical_fish:　　2.　Build a DB
```console
fishingz -i
```
In the initial setting, the following file system is excluded from searching.
```
/lost+found 　/snap 　/proc 　/sbin 　/media 　/root 　/opt
/srv 　/cdrom 　/lib64 　/mnt 　/run 　/tmp 　/lib 　/dev
```

With this you can use fishingz.

　

## <img src="http://placehold.jp/24/39aaff/ffffff/180x40.png?text=Advanced%20Setup">


The following can be done as necessary.
　 

### :dolphin:　　1.　Set up fishingz

The configuration file is $ HOME / .fishingz / init.fish.

|変数|処理内容|デフォルト値|
|---|:--|:--|
|FISHINGZ_F_ACTIONS|Define the application you want to use according to the file type||
|FISHINGZ_DB_REBLD_THLD_C|Number of times fishingz used to rebuild DB|50|
|FISHINGZ_DB_REBLD_THLD_T|Elapsed time to DB reconfiguration (sec)|86400(sec)=1day|
|FISHINGZ_NPROC_ON_REBUILD|Number of CPUs used for DB reconstruction|1個|
|FISHINGZ_HISTMAX|Number of MRUs to keep|1000|
|FISHINGZ_COLOR_D|Display color of directory when opening DB|32m (green)|
|FISHINGZ_COLOR_F|Display color of file when opening DB|36m (cyan)|
|FISHINGZ_COLOR_L|Symbolic link display color when opening DB|35m (purple)|
|FISHINGZ_COLOR_M|MRU display color when opening DB|33m (yellow)|
|FISHINGZ_FZF_COLOR|Color setting in fzf mode||
|FISHINGZ_HISTMAX|Key setting for single line copy processing in fzf mode||
|FISHINGZ_EXCLUDE_FS|File system you want to exclude from DB|/lost+found, /snap, /proc, /sbin, ...|
|FISHINGZ_EXCLUDE_DIR|Directory you want to exclude from DB|.git, .svn, CVS|
　

When setting the above table, please describe as follows.
　

***$HOME/.fishingz/init.fish***  
```
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# Command to execute in case of [f]
# file-type : command : use sudo when readonly file : redirect : background 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
set -g  FISHINGZ_F_ACTIONS  '
  "text/html"       : "setsid google-chrome" : ""     : "1>/dev/null 2>/dev/null" : "&"  
  "application/xml" : "setsid google-chrome" : ""     : "1>/dev/null 2>/dev/null" : "&"  
  "text/html"       : "setsid google-chrome" : "sudo" : "1>/dev/null 2>/dev/null" : "&"  
  "text/xml"        : "setsid google-chrome" : "sudo" : "1>/dev/null 2>/dev/null" : "&"  
  "text"            : "nvim"                 : "sudo" : ""                        : ""   
  "image"           : "setsid xdg-open"      : ""     : "1>/dev/null 2>/dev/null" : "&"  
  "inode/x-empty"   : "nvim"                 : ""     : ""                        : ""
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
set -g  FISHINGZ_DB_REBLD_THLD_C  50      # 50 reps
set -g  FISHINGZ_DB_REBLD_THLD_T  86400   # 1day=3600(sec)*24

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
```

　
