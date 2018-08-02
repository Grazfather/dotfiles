#!/bin/bash
set -e

dir=$PWD
backup=$HOME/dotfiles.bak

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
        # Create symlink
        ln -s $dir/$filename $HOME/.$filename
    fi
done

# Pull in submodules
git submodule init && git submodule update

# Install vim plugins
vim +'PlugInstall --sync' +qa
