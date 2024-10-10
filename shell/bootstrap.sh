# Ensure that user-installed or custom tools take priority over system
# binaries. Facilitates customization and local control over the evnironment
# without needing administrative rights

# Prepend the .local/bin directory to the PATH
path_prepend "$HOME/.local/bin"

# Prepend the .dotfiles/bin directory to the PATH
path_prepend "$HOME/.dotfiles/bin"