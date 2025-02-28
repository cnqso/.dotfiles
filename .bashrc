#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias browser='firefox & disown & exit'
alias ls='ls --color=auto'
alias hyprconf="nvim ~/.config/hypr/hyprland.conf"
alias bashconf="nvim ~/.bashrc"
alias headphones="bluetoothctl connect 4C:87:5D:50:87:6C"
alias keyboard="bluetoothctl connect DC:2C:26:EF:B8:13"
alias rebash="source ~/.bashrc"
alias conf="cd ~/.config"
alias drive1="cd /mnt/sda"
alias drive2="cd /mnt/sdb"
alias grep='grep --color=auto'
alias f='fastfetch'
# Custom Bash Prompt
set_prompt() {
  # Capture exit status of last command
  local EXIT_STATUS="$?"

  # Top line with user, host, date, time
  local TOP_LINE="\[\e[41;30m\] 󰣇 \[\e[42;31m\]\[\e[42;30m\] \u \[\e[46;32m\]\[\e[46;30m\] \h \[\e[45;36m\]\[\e[45;30m\] \t \[\e[0m\]"
  # Bottom line with lambda and working directory

  local LAMBDA="λ"
  if [ $EXIT_STATUS -eq 0 ]; then
    LAMBDA="\[\e[32m\]$LAMBDA\[\e[0m\]"
  else
    LAMBDA="\[\e[31m\]$LAMBDA\[\e[0m\]"
  fi

  local BOTTOM_LINE="\n$LAMBDA "

  PS1="$TOP_LINE$BOTTOM_LINE"
}

PROMPT_COMMAND='set_prompt'

export PATH="~/.dotfiles/bin:$PATH"
