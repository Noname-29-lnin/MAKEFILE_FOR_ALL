#########################################################################
# ~/.bashrc - Noname-29-lnin
#########################################################################

[[ $- != *i* ]] && return

# Source global definitions nếu có
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

umask 002
export TZ="Asia/Ho_Chi_Minh"
export LC_CTYPE="en_US.UTF-8"
export TERM="xterm-256color"

############################################
# Shell behavior (Bash equivalents)
############################################
# --- Bash hoàn toàn tự động tab completion theo mặc định ---
bind "set completion-ignore-case on"     
bind "set show-all-if-ambiguous on"     

# --- Notify background job status changes immediately ---
set -b

# --- History and safety defaults ---
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups 
shopt -s histappend                    

set -o ignoreeof                       
set -o noclobber                       

############################################
# Colors + Prompt (Bash PS1 Syntax)
############################################
c_reset="\[\033[0m\]"
c_white="\[\033[37m\]"
c_red="\[\033[31m\]"
c_green="\[\033[32m\]"
c_yellow="\[\033[33m\]"
c_blue="\[\033[34m\]"

export PS1="${c_red}[ \u ] ${c_green}[ \h ] ${c_yellow}[ \$(date '+%a - %d.%m.%Y') ]${c_white}[ ${c_blue}B${c_red}O${c_green}S${c_white} ] ${c_blue}[ \w ]\n${c_white} -> ${c_reset}"

############################################
# Tool environments (EDA)
############################################
export CADHOME=/opt/cadence
export CDS_LIC_FILE=$CADHOME/license/license.dat
export CDS_LIC_ONLY=1
export CDS_AUTO_64BIT=ALL
export LANG=C
export CDS_Netlisting_Mode=Analog
export CDS_LOAD_ENV=CWD
export MOZILLA_HOME=/usr/bin/firefox
export MGC_PDF_READER=atril

export CDS=$CADHOME/IC618
export CDSDIR=$CDS
export CDSHOME=$CDS
export CADENCE_DIR=$CDS
export CDS_INST_DIR=$CDS
export CDS_ROOT=$CDS
export CDSROOT=$CDS

# Cập nhật PATH chuẩn Bash
export PATH=$PATH:$CDSDIR/tools/dfII/bin:$CDSDIR/tools/plot/bin

export CDS_ENABLE_VMS=1
export MMSIMHOME=$CADHOME/MMSIM151
export PATH=$PATH:$MMSIMHOME/bin:$MMSIMHOME/tools/relxpert/bin

export GENUSHOME=$CADHOME/GENUS152
export PATH=$PATH:$GENUSHOME/tools/bin
export PATH=$PATH:$CADHOME/XCELIUM2009/bin:$CADHOME/XCELIUM2009/tools/bin

## MENTOR GRAPHICS CALIBRE
export MGC_HOME=/opt/mentor
export CALIBRE_HOME=$MGC_HOME/calibre/aoi_cal_2021.2_28.15
export MGLS_LICENSE_FILE=$MGC_HOME/license/license.dat
export PATH=$PATH:$CALIBRE_HOME/bin
export MGC_LIB_PATH=$CALIBRE_HOME/lib
export USE_CALIBRE_VCO=aoi
export MGC_CALIBRE_REALTIME_VIRTUOSO_ENABLED=1
export OA_PLUGIN_PATH=$CALIBRE_HOME/shared/pkgs/icv/tools/queryskl

if [ -z "${LD_LIBRARY_PATH+x}" ]; then
    export LD_LIBRARY_PATH=${CALIBRE_HOME}/shared/pkgs/icv/tools/calibre_client/lib/64
else
    export LD_LIBRARY_PATH=${CALIBRE_HOME}/shared/pkgs/icv/tools/calibre_client/lib/64:${LD_LIBRARY_PATH}
fi

export MGC_CALIBRE_REALTIME_VIRTUOSO_SAVE_MESSENGER_CELL=1
export MGC_CALIBRE_SAVE_ALL_RUNSET_VALUES=1
export MGC_CALIBRE_SCHEMATIC_SERVER=centos7:9199
export MGC_CALIBRE_LAYOUT_SERVER=centos7:9189

############################################
# Aliases / User functions
############################################
alias b='cd ..'
alias bb='cd ../..'
alias bbb='cd ../../..'
alias bbbb='cd ../../../..'
alias z='cd -'

cd() {
    builtin cd "$@" && clear && ls -aF
}

alias c='clear; ls -aF'

alias bashconfig='vim ~/.bashrc'
alias bashsource='clear; source ~/.bashrc; printf "\n$ -> Saving new configuration...\n\n"'
alias vimconfig='vim ~/.vimrc'
alias h='history'
alias tmux_new='tmux new -s'
alias tmux_attach='tmux attach -t'
alias tmux_kill='tmux kill-session -t'

alias mntsh="sudo /usr/bin/vmhgfs-fuse .host:/ /home/admin/shared -o subtype=vmhgfs-fuse,allow_other,nonempty,default_permissions,uid=\$(id -u),gid=\$(id -g)"