dotfiles
========

My collection of dotfiles for vim, bash, git, and tmux.

Running `init.sh` will symlink _$HOME/.{file}_ to _/path/to/dotfiles/{file}_, and back up the original in _$HOME/dotfiles.bak/_, pull in all the vim plugin submodules, and install git aliases and bash aliases in the appropriate rc file.
