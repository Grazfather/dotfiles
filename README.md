# dotfiles

My collection of dotfiles for the various tools I use.

## Prerequisites

* [babashka](https://babashka.org)
* git
* vim/neovim

Running `bb setup` will symlink the dotfiles in the repo into their appropriate
location, set up your _.bashrc_ and _.gitconfig_ to use the aliases, and add
this repo's _bin/_ to your `PATH`.

Original files will be backed up to _\<FILE\>.bak_.
