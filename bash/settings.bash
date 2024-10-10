# history settings

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# avoid logging unnecessary commands
HISTIGNORE="&:ls:[bf]g:exit"

# include timestamps for better auditing
HISTTIMEFORMAT="%F %T "

# shell options

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set the default editor
export EDITOR=vi