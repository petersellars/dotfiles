# Prompt escape sequences

# Sets text to bold or bright mode
ATTRIBUTE_BOLD='\[\e[1m\]'

# Resets all text attributes back to normal
ATTRIBUTE_RESET='\[\e[0m\]'

# Sets text to the defaul terminal foreground colour
COLOR_DEFAULT='\[\e[39m\]'

# Change the text colour to the specified colour
COLOR_RED='\[\e[31m\]'
COLOR_GREEN='\[\e[32m\]'
COLOR_YELLOW='\[\e[33m\]'
COLOR_BLUE='\[\e[34m\]'
COLOR_MAGENTA='\[\e[35m\]'
COLOR_CYAN='\[\e[36m\]'
COLOR_GRAY='\e[38;5;246m'
COLOR_LIGHT_BLUE='\[\e[94m\]'

# Display the machine name using the hostname
# or a custom name set in the ~/.name file
machine_name() {
    if [[ -f $HOME/.name ]]; then
        cat $HOME/.name
    else
        hostname
    fi
}

# Limit the prompt to the last 3 directories
PROMPT_DIRTRIM=3

# Primary prompt
# \n - prompt starts on a new line
# Displays a hash symbol followed by the username and machine name in cyan and magenta respectively
# Displays 'in' in green
# Displays the current working directory in yellow
# \n - adds another new line
# If the last command exited with a non-zero status, display a red exclamation mark
# Displays a blue greater than symbol as a prompt
PS1="\n${COLOR_BLUE}#${COLOR_DEFAULT} \
${COLOR_CYAN}\\u${COLOR_DEFAULT} \
${COLOR_GREEN}at${COLOR_DEFAULT} \
${COLOR_MAGENTA}\$(machine_name)${COLOR_DEFAULT} \
${COLOR_GREEN}in${COLOR_DEFAULT} \
${COLOR_YELLOW}\w${COLOR_DEFAULT}\
\$(if git rev-parse --abbrev-ref HEAD &>/dev/null; then echo \"${COLOR_LIGHT_BLUE}(\$(git rev-parse --abbrev-ref HEAD))${COLOR_DEFAULT} \"; fi)\n \
\$(if [ \$? -ne 0 ]; then echo \"${COLOR_RED}!${COLOR_DEFAULT} \"; fi) \
${COLOR_BLUE}>${COLOR_DEFAULT} "

# Secondary prompt, used when a command spans multiple lines
PS2="${COLOR_BLUE}>${COLOR_DEFAULT} "

# Switch to a short prompt for demo purposes, screenshots
# or presentations
# Displays the current working directory in gray
# If the current directory is a git repository, display the branch name in light blue
# Displays a blue dollar sign symbol as a prompt
demoprompt() {
    PROMPT_DIRTRIM=1
    PS1="${COLOR_GRAY}\w\
\$(if git rev-parse --abbrev-ref HEAD &>/dev/null; then echo \"${COLOR_LIGHT_BLUE}(\$(git rev-parse --abbrev-ref HEAD))${COLOR_DEFAULT} \"; fi)\
${COLOR_BLUE}\$${COLOR_DEFAULT} "
    trap '[[ -t 1 ]] && tput sgr0' DEBUG
}