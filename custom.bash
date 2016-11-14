#!/bin/bash

[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

color_prompt=yes
alias ls='ls --color=auto'
#PS1='docker:(\h) \u \w $(__git_ps1 "git:(%s)") '
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

RESET="\[\033[0m\]" # unsets color to term's fg color

# regular colors
K="\[\033[0;30m\]" # black
R="\[\033[0;31m\]" # red
G="\[\033[0;32m\]" # green
Y="\[\033[0;33m\]" # yellow
B="\[\033[0;34m\]" # blue
M="\[\033[0;35m\]" # magenta
C="\[\033[0;36m\]" # cyan
W="\[\033[0;37m\]" # white

# emphasized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"

PS1="${R}[Docker]${G}\u${Y}@\h${RESET}: \w\$(__git_ps1 ' ${B}git:(${R}%s${B})')${RESET} "

