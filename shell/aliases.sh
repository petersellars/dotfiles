# Use colors in coreutils utilities output
alias ls='ls --color=auto'
alias grep='grep --color'

# ls aliases
# -h: human readable sizes
alias ll='ls -lAh'
# -A: do not list implied . and ..
alias la='ls -A'
alias l='ls'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
# Alias to protect against accidental deletion
alias rm='rm -i'

# Create a directory and cd into it
mcd() {
    mkdir -p "${1}" && cd "${1}"
}

# Update dotfiles
dfu() {
    (
        cd ~/.dotfiles && git pull --ff-only && ./install -q
    )
}