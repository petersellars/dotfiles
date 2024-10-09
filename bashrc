# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Functions
source ~/.shell/functions.sh

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.bashrc_local_before file
if [ -f ~/.bashrc_local_before ]; then
    source ~/.bashrc_local_before
fi

# Plugins
source ~/.bash/plugins.bash