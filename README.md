dotfiles
========

My collection of dotfiles for vim, bash, git, and tmux.

Running `init.sh` will symlink _$HOME/.{file}_ to _$HOME/dotfiles/{file}_, and back up the original in _$HOME/dotfiles.bak/_ as well as pull in all the vim plugin submodules.

Make sure that _.bash_aliases_ is called from your _.bashrc_:

```
echo "if [ -f $HOME/.bash_aliases ]; then . $HOME/.bash_aliases; fi" >> ~/.bashrc
```
