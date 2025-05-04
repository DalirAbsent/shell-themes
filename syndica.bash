function command_prompt()
{
    local exit_code=$?
    reset_color="\[\e[0;38;5;255m\]"
    local user_host="\[\e[1;38;5;33m\]\u㉿\h$reset_color"
    local current_dir="\[\e[1;38;5;10m\]\w$reset_color"
    local user_symbol="\[\e[1;38;5;255m\]\$$reset_color"
    local new_line=""
    local error_code=""
    local venv_info=""
    local git_info=""
    
    read -sdR -p $'\E[6n' cursor_pos
    local col_pos=${cursor_pos##*;}

    if [ $col_pos -ne 1 ]; then
        new_line="%\n"
    fi

    if [ $exit_code -ne 0 ]; then
        error_code="\[\e[1;38;5;1m\]$exit_code ↵$reset_color"
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
        venv_info="$(venv_prompt)$reset_color"
    fi

    if [ $(git rev-parse --is-inside-work-tree 2> /dev/null) ]; then
        git_info="$(git_prompt)$reset_color"
    fi

    PS1="$reset_color$new_line╭─($user_host)-[$current_dir]$venv_info$git_info $error_code\n╰─$user_symbol "
}

function venv_prompt()
{
    local venv_name=$(basename "$VIRTUAL_ENV")
    local prompt="$reset_color{\[\e[1;38;5;69m\]$venv_name$reset_color}"

    echo "$prompt"
}

function git_prompt()
{
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local status=$(git status --porcelain)
    local dirty=""

    if [ -n "$status" ]; then
        dirty="\[\e[1;38;5;196m\] ✗ $reset_color"
    fi

    local prompt="$reset_color->(\[\e[1;38;5;93m\]git:$reset_color[\e[1;38;5;214m\]$branch$reset_color]$dirty)"

    echo "$prompt"
}

PROMPT_COMMAND=command_prompt
