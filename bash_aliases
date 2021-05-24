# ls aliases
alias la='ls -A'
alias lh='ls -lh'
alias ll='ls -alF'
alias l='ls -CF'

# navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# suppress the copyright info when starting gdb
alias gdb='gdb -q'

# Ripgrep ignores hidden files and .gitignore files. rga to search them.
alias rga="rg --no-ignore --hidden --glob '!.git'"

alias lsusbx='ioreg -p IOUSB -l -w 0|grep "\-o"'

alias vim='$(command -v nvim || echo vim)'
