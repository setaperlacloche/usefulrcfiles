export TERM="xterm-256color"
export COLORTERM="truecolor"
export LS_COLORS='no=00:fi=00:di=01;33:ex=01;37:*.ace=01;32:*.tar=01;32:*.tgz=01;32:*.arj=01;32:*.taz=01;32:*.lzh=01;32:*.zip=01;32:*.z=01;32:*.Z=01;32:*.gz=01;32:*.bz2=01;32:*.deb=01;32:*.rpm=01;32:*.sit=01;32:*.rar=01;32:*.dmg=01;32:*.jpg=01;35:*.JPG=01;35:*.jpeg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.pdf=01;35:*.ppm=01;35:*.ps=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.wmv=01;33:*.mpg=01;33:*.mov=01;33:*.mpeg=01;33:*.avi=01;33:*.ogm=01;33:*.mp3=01;33:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.txt=01;36:*.php=01;36:*.c=01;36:*.cfg=01;36:*.log=01;36:*.ini=01;36:*.sql=01;36:*.tpl=01;36:*.nfo=01;36:'
export GREP_COLORS='ms=01;31:mc=01;31:sl=01;37:cx=:fn=01;33:ln=01;32:bn=01;32:se=01;36'
export LESS=" -X -R"

export CLICOLOR=true
export CLICOLOR_FORCE=true
export NNTPSERVER=''
export SVN_EDITOR='emacs -nw'

# some aliases
alias wc="wc 2> /dev/null"
alias l="ls --color"
alias ll="ls -l --color"
alias la="ls -la --color"
alias lar="ls -laR --color"
alias cc=gcc
alias c=clear
alias scr="screen -dR"
alias ..="cd .."
alias grep="grep --color"
alias mydiff="diff -b --suppress-common-lines -y --width=\$(tput cols)"
alias mygcc="gcc -W -Wall -ansi -Werror -pedantic"
alias emacs="emacs -nw"
alias n="nslookup"
alias json="python3 -m json.tool"
if [[ -f "/etc/debian_version" ]]; then
  major=$(grep -o "^[0-9]*" /etc/debian_version)
  if [[ $major == "9" || $major == "10" ]]; then
    alias nano="nano --smooth --tabsize=4 --showcursor"
    alias nanom="nano --smooth --tabsize=4 --mouse"
  elif [[ $major == "11" || $major == "12" || $major == "13" ]]; then
    alias nano="nano --tabsize=4 -K"
    alias nanom="nano --tabsize=4 --mouse"
  fi
  unset major
fi
if [[ -f /etc/apt/apt.conf ]]; then
  alias wgetproxy="wget -e use_proxy=yes -e https_proxy=$(grep -i '^Acquire::http::Proxy' /etc/apt/apt.conf | awk -F '"' '{print $2}')"
else
  alias wgetproxy="wget"
fi
alias ff="find / -name"
alias f.="find . -name"
alias iff="find / -iname"
alias if.="find . -iname"
alias les="less -S"
alias sslget='openssl s_client </dev/null -showcerts'
alias sslcat='openssl x509 -text -in'
alias ss="sudo su"
alias uu="sudo apt-get update && sudo apt-get dist-upgrade -y"
alias 777='chmod 777'
alias 700='chmod 700'
alias 600='chmod 600'
alias 500='chmod 500'
alias 750='chmod 750'
alias 755='chmod 755'
alias 766='chmod 766'
alias 555='chmod 555'
alias 644='chmod 644'
alias 666='chmod 666'
alias 444='chmod 444'
alias 400='chmod 400'
alias -- +x='chmod +x'
alias du1="du --max-depth=1 --exclude '*/proc/*' -h"
alias du2="du --max-depth=2 --exclude '*/proc/*' -h"
alias f64='od -An -w8 -tfD'
alias size='find . -type f -printf "%s\n" | awk "{sum+=\$1} END {print sum}"'
alias pmake="time nice make -j$(nproc) --load-average=$(nproc)"
if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
	alias performance="echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
	alias powersave="echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
	alias ondemand="echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
	alias freq="cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
fi

compctl -g "*.s" cw cw5 cw5m cw6 cw6m
# fpath
fpath=(~/fpath $fpath)

# a fancy prompt

autoload -U colors
colors

setopt prompt_subst
setopt interactivecomments
##
## prompt for corrections
##
SPROMPT="zsh: %4(T,%B%{you need some sleep; %}%b,)correct "%{$fg[red]%}"%B'%R'%b"%{$fg[default]%}" to "%{$fg[green]%}"%B'%r'%b"%{$fg[default]%}" ? [nyae] "

##
## Menu on completion
##
zstyle ':completion:*' menu select
bindkey '^[[Z' reverse-menu-complete

### LISTPROMPT="%BAt %L: Hit TAB for more, or the character to insert%b"

function precmd
{
  local TERMWIDTH
  (( TERMWIDTH = ${COLUMNS} - 1 ))

  ###
  # Truncate the path if it's too long.
  PR_FILLBAR=""
  PR_PWDLEN=""

  local promptsize=${#${(%):-"\`%?\`  [%n@%m]%T"}}
  local pwdsize=${#${(%):-%~}}

  while [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; do
    pwdsize=$(($pwdsize - $TERMWIDTH))
  done
  PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize))).. .)}"
}
setopt extended_glob
showprompt ()
{
  for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
  done
  PR_NO_COLOR="%{$fg[default]%}"

PROMPT=%B$PR_WHITE'\`'%(?.$PR_RED.)'%?'$PR_WHITE'\` '\
$PR_YELLOW'['$PR_CYAN'%n'$PR_RED'@'$PR_CYAN'%m'$PR_YELLOW']'\
$PR_GREEN'%~${(e)PR_FILLBAR}'$PR_WHITE'%T%<<\

$PR_YELLOW%#$PR_NO_COLOR '
}

showprompt

# umask
umask 077

# Program some nice completion things. First some useful
# arrays:
hosts=("${(s: :)${(s:   :)${${(f)$(</etc/hosts)}%%\#*}#*[       ]*}}")
groups=( "${${(f)$(</etc/group)}%%:*}" )

# Set default completion to look through all files, then
# the command history.

compctl -D -f + -H 0 '' -X '(No file found; using history)'

compctl -o setopt
compctl -v echo export
compctl -z -P '%' bg
compctl -j -P '%' fg jobs disown
compctl -j -P '%' + -s '`ps -x | tail +2 | cut -c1-5`' wait
compctl -A shift
compctl -c type whence where which whereis killall man apropos
compctl -g '*(*)' strip gprof adb dbx xdbx ups
compctl -g '*.[ao]' -g '*(*)' nm

function ns_a1 { reply=(`ns_who -g | grep a1 | cut -d@ -f1`); }
function ns_hosts { reply=(`ns_hwho | grep -i netbsd_wse | cut -d' ' -f1`); }
compctl -k "(all clean distclean re update commit dep depends check dist install)" make
compctl -K ns_a1 ns_send_msg
compctl -K ns_a1 ns
compctl -K ns_hosts ssh

# kill takes signal names as the first argument after `-',
# but job names after % or PIDs as a last resort.

compctl -j -P '%' + -s '`ps -x | tail +2 | cut -c1-5`' + \
    -x 's[-] p[1]' -k "($signals[1,-3])" -- kill

# This one is very handy: ensures that cd <tab> cycles
# through directories (including "hidden" .directories)
# only. Likewise rmdir.

compctl -g "*(-/) .*(-/)" cd rmdir

compctl -g "*.html *.htm" + -g "*(-/) .*(-/)" + -H 0 '' mozilla

# completions for applications

autoload -U compinit
compinit

# Make home, insert, delete and end work on PCs basically
# like in doskey. This may or may not work for you... the
# \e is the ESC character. To set this up for your favourite
# system, type cat > rubbish, press the keys of interest,
# then enter here what you see. You should replace ^[
# (escape) with \e.
bindkey "\e[1~" beginning-of-line
bindkey "\e[H"  beginning-of-line
bindkey "\eOH"  beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[F"  end-of-line
bindkey "\e[OF" end-of-line
bindkey "^[OF"  end-of-line
bindkey "\e[2~" transpose-words
bindkey "\e[3~" delete-char
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "^?" backward-delete-char

tabs -4

# make backspace works properly
stty erase '^h'

# This makes the shell give immediate notice of changes in job status.
setopt NOTIFY

setopt EXTENDED_GLOB

# history
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
HISTSIZE=3000
SAVEHIST=3000
HISTFILE=~/.zsh_history

# pushd/popd
DIRSTACKSIZE=8
setopt autopushd pushdminus pushdsilent pushdtohome
alias dh='dirs -v'

# cd
setopt AUTOCD

# auto correction
setopt CORRECT
setopt DVORAK
setopt PATH_DIRS
#setopt PRINT_EXIT_VALUE

# help
export HELPDIR='/usr/share/zsh/help'
alias help=run-help

setopt AUTO_RESUME

export PATH=$PATH:/usr/sbin

function difflinebyline()
{ # Compare line by line two files, out side by side unmatched lines
  paste $1 $2 | grep -Pv '(.*)\t\K\1$'
}

function nanorcupdate()
{
    (( $EUID != 0 )) && { echo "This command required root privileges"; return 1 }
    wgetproxy 'https://github.com/setaperlacloche/usefulrcfiles/raw/main/python.nanorc' -O /usr/share/nano/python.nanorc
    wgetproxy 'https://github.com/setaperlacloche/usefulrcfiles/raw/main/nanorc' -O /etc/nanorc
    echo "nanorc files updated"
}

function zrcadd()
{
    (( $EUID != 0 )) && { echo "This command required root privileges"; return 1 }
    (( $# != 1 )) && { echo "An username must be supplied"; return 1 }
    if id "$1" &>/dev/null; then        # Test if user exists
        (
        set -e
        echo "Set default shell of user $1..."
        chsh -s /bin/zsh "$1"
        echo "Copy .zshrc file to $1 home folder..."
        install -o "$1" -g $(id -gn "$1") -m 644 /root/.zshrc ~$1
        echo -e "\033[37mDone for user $1\033[m"
        )
    else
        echo "$1 user not found"
        return 1
    fi
}

# Mise à jour du .zshrc depuis le cloud
function zrcupdate()
{
  wgetproxy 'https://github.com/setaperlacloche/usefulrcfiles/raw/main/.zshrc' -O ~/zshrc.tmp

  if [[ $? -eq 0 ]]; then
     mv ~/zshrc.tmp ~/.zshrc && chmod 700 ~/.zshrc && { echo 'Success !' && return 0; }
  fi
  rm ~/zshrc.tmp
  echo -e '\e[1;31mFAILED !\e[0m'
  return 1
}
# Binary files to hex dump 8/16/32 columns
function hex8() {
    xxd -c 8 "$1" > "${1%.bin}.hex8"
}
function hex16() {
    xxd -c 16 "$1" > "${1%.bin}.hex16"
}
function hex32() {
    xxd -c 32 "$1" > "${1%.bin}.hex32"
}
# Find text in binary file, exit offset and matched pattern
alias fnd="LC_ALL=C grep --byte-offset --only-matching --text"
# Decimal value to hex
alias d2h="printf '%x\n'"
# Hex (0x) to Decimal value
function h2d() { printf '%d\n' 0x$1 }

function original() { cp -p $1 $1.original }
function useful() { grep -v '^$' $1 | grep -v "^[[:space:]]*[#;]" }
function ppgrep() { pgrep "$@" | xargs --no-run-if-empty ps fp; }
function lastm()   { find $1 -type f -print0 | xargs -0 stat --printf '%y\t%n\n' | sort -n }
function 7tmp()     { bn=$(basename "$1") && cp "$1" "/tmp/$bn"; chmod 777 "/tmp/$bn" }

[ -e ~/.zshrc2 ] && . ~/.zshrc2
