#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" ; pwd -P)"
backup=$HOME/dotfiles.bak

function status {
    echo "[*]" $@
}

# Setup symlinks
for file in $DIR/*; do
    filename=$(basename $file)
    if [[ "$filename" != "$(basename $0)" ]]; then
        if [ -e $HOME/.$filename ]; then
            if ! [ -h $HOME/.$filename ]; then
                mkdir -p $backup
                # Move existing dotfile to $backup
                mv $HOME/.$filename $backup/
            else
                status .$filename is already symlinked
                continue
            fi
        fi
        status "Creating link for .$filename"
        ln -s $DIR/$filename $HOME/.$filename
    fi
done

# Pull in submodules
pushd $DIR >/dev/null
git submodule init && git submodule update
popd >/dev/null

# Install vim plugins
vim +'PlugInstall --sync' +qa

# Install bash aliases
if ! grep -q bash_aliases $HOME/.bashrc; then
    echo "# Set up aliases" >> $HOME/.bashrc
    echo "[ -f \$HOME/.bash_aliases ] && source \$HOME/.bash_aliases" >> $HOME/.bashrc
else
    status ".bash_aliases already in .bashrc"
fi

# Install git aliases
if ! grep -q gitaliases $HOME/.gitconfig 2>/dev/null; then
    echo "[include]" >> $HOME/.gitconfig
    echo "	path = ~/.gitaliases" >> $HOME/.gitconfig
else
    status ".gitaliases already in .gitconfig"
fi
