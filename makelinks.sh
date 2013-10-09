#!/bin/bash

dir=$HOME/dotfiles
backup=$HOME/dotfiles.bak

mkdir -p $backup

for file in $dir/*
do
    filename=$(basename $file)
    if [[ -f $file ]]; then
        if [[ "$filename" != "$(basename $0)" ]]; then
            echo "Creating link for .$filename"
            # Move existing dotfile to $backup
            mv $HOME/.$filename $backup/
            # Create symlink
            ln -s $dir/$filename $HOME/.$filename
        fi
    fi
done
