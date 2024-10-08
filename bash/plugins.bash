# dircolors
# Enhances the visibility of different types of files (directories,
# executables, symlinks etc.) by using colour coding, making it
# easier to identify them at a glance.
if [[ "$(tput colors)" == "256" ]]; then
    eval "$(dircolors ~/.shell/plugins/dircolors-solarized/dircolors.256dark)"
fi