# Define colors
_omb_prompt_bold_green='\[\e[1;32m\]'
_omb_prompt_bold_blue='\[\e[1;34m\]'
_omb_prompt_bold_yellow='\[\e[1;33m\]'
_omb_prompt_bold_red='\[\e[1;31m\]'
_omb_prompt_reset_color='\[\e[0m\]'

# Git branch information
function scm_prompt_info() {
  local branch
  branch=$(git symbolic-ref HEAD 2>/dev/null | awk -F/ '{print $NF}')
  if [ -n "$branch" ]; then
    branch="(${branch})"
  fi

  echo "${branch}"
}

# Virtual environment information
function scm_venv_prompt_info() {
  local venv
  if [ -n "$VIRTUAL_ENV" ]; then
    venv="($(basename $VIRTUAL_ENV))"
  fi

  echo "${venv}"
}

# Prompt command
function _omb_theme_PROMPT_COMMAND() {
  local TITLEBAR
  local PWD_DISPLAY
  case $TERM in
    xterm* | screen)
      TITLEBAR="\n"$(scm_venv_prompt_info)$'\1\e]0;'$USER@${HOSTNAME%%.*}:${PWD/#$HOME/~}$'\e\\\2' ;;
    *)
      TITLEBAR= ;;
  esac

  PWD_DISPLAY=${PWD/#$HOME/\~}

  PS1=$TITLEBAR"\n${_omb_prompt_bold_green}\u@\h ${_omb_prompt_bold_yellow}${PWD_DISPLAY} ${_omb_prompt_bold_blue}$(scm_prompt_info)\n${_omb_prompt_bold_red}\$ ${_omb_prompt_reset_color}"
}

# Add the prompt command
_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND