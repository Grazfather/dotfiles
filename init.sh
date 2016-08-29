#!/bin/bash

dir=$PWD
backup=$HOME/dotfiles.bak

mkdir -p $backup

for file in $dir/*
do
    filename=$(basename $file)
            echo $file
    if [[ "$filename" != "$(basename $0)" ]]; then
        echo "Creating link for .$filename"
        # Move existing dotfile to $backup
        mv $HOME/.$filename $backup/
        # Create symlink
        ln -s $dir/$filename $HOME/.$filename
    fi
done

# Pull in submodules
git submodule init && git submodule update
