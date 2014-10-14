# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# git aliases
alias gits="git status"
alias gitco="git checkout"
alias gitd="git diff"
alias gitdc="git diff --cached"
alias gith="git hist"
alias gitb="git branch"
alias gitca="git commit --amend"
alias gitrc="git rebase --continue"
alias gitfo="git fetch origin"
alias gitsl="git stash list"
alias gitsp="git-stash-pop"

function git-stash-pop
{
	if [ -z "$1" ]
	then
		git stash pop
		return
	fi

	git stash pop stash@{$1}
}

# navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# suppress the copyright info when starting gdb
alias gdb='gdb -q'
