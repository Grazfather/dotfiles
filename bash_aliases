# ls aliases
alias la='ls -A'
alias lh='ls -lh'
alias ll='ls -alF'
alias l='ls -CF'

# navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
# -- cd to the top of the current git repo
alias tot='cd $(git rev-parse --show-toplevel)'

# suppress the copyright info when starting gdb
alias gdb='gdb -q'

# Ripgrep ignores hidden files and .gitignore files. rga to search them.
alias rga="rg --no-ignore --hidden --glob '!.git'"
# Ripgrep, ignore vendor
alias rgnv="rg -g '!vendor'"

alias lsusbx='ioreg -p IOUSB -l -w 0|grep "\-o"'
lsusbxt() {
  if [ -z "$1" ]; then
    echo "Usage: usbtree <device-name>"
    return 1
  fi
  ioreg -r -n "$1" -l -w 0 | grep "+-o"
}

alias vim='$(command -v nvim || echo vim)'
