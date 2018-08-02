#!/bin/bash
set -e

dir=$(dirname "$0")
backup=$HOME/dotfiles.bak


# Setup symlinks
for file in $dir/*; do
    filename=$(basename $file)
    echo $file
    if [[ "$filename" != "$(basename $0)" ]]; then
        if [ -e $HOME/.$filename ]; then
            mkdir -p $backup
            # Move existing dotfile to $backup
            mv $HOME/.$filename $backup/
        fi
        echo "Creating link for .$filename"
        ln -s $dir/$filename $HOME/.$filename
    fi
done

# Pull in submodules
git submodule init && git submodule update

# Install vim plugins
vim +'PlugInstall --sync' +qa

# Install bash aliases
if ! grep -q bash_aliases $HOME/.bashrc; then
    echo "# Set up aliases" >> $HOME/.bashrc
    echo "[ -f \$HOME/.bash_aliases ] && source \$HOME/.bash_aliases" >> $HOME/.bashrc
fi

# Install git aliases
if ! grep -q gitaliases $HOME/.gitconfig 2>/dev/null; then
    echo "[include]" >> $HOME/.gitconfig
    echo "	path = ~/.gitaliases" >> $HOME/.gitconfig
fi
