# These shell functions aim to improve productivity and make the shell more
# user-friendly.

# Remove a specific directory from the PATH
path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

# Prepend a directory to the PATH if it exists
path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

# Searches through your command history for a given keyword
# will ignore itself and the histgrep command
histgrep() {
    history | grep "$1" | grep -v "histgrep"
}

# Clear history and remove it from disk
histclear() {
    history -c
    history -w
}

# Creates or updates a symbolic link to the current directory
# called .shell.here in your home directory. You can specify
# a directory or use without arguments to link to the current
# directory.
here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink $HOME/.shell.here)"
}

# Shell variable that holds the path to the symbolic link
# .shell.here in your home directory.
there="$HOME/.shell.here"

# Uses readlink to change to the directory that 
# .shell.here symbolic link points to.
there() {
    cd "$(readlink "${there}")"
}