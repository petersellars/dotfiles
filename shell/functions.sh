# These shell functions aim to improve productivity and make the shell more
# user-friendly.

# Searches through your command history for a given keyword
histgrep() {
    history | grep "$1"
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