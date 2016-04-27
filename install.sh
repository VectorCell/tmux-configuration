#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "This script should be run from the directory where it resides."

echo "This script will overwrite the following files (if they exist):"
echo -e "\t~/.tmux.conf"
for file in $(ls | grep "tmux-"); do
	echo -e "\t~/bin/$file"
done

while true; do
read -p "Do you wish to install this program? [y/n]:" yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) echo "not installing, exiting ..."; exit;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo "Installing ..."
if [ -e "$HOME/.tmux.conf" ]; then
	echo -e "\nremoving $HOME/.tmux.conf"
	rm "$HOME/.tmux.conf"
fi

version=$(tmux -V | tr '.' ' ' | awk '{print $2}')

if [ "$version" == 1 ]; then
	echo "Installing configuration for tmux version 1"
	sourcefile=tmux.conf
elif [ "$version" == 2 ]; then
	echo "Installing configuration for tmux version 2"
	sourcefile=tmux2.conf
else
	echo "ERROR: unknown tmux version: $(tmux -V)"
	exit 1
fi

echo -e "linking $HOME/.tmux.conf to $DIR/$sourcefile"
ln -s $DIR/$sourcefile $HOME/.tmux.conf
for file in $(ls | grep "tmux-"); do
	if [ -e "$HOME/bin/$file" ]; then

		echo -e "\nremoving $HOME/bin/$file"
		rm "$HOME/bin/$file"
	fi
	echo -e "linking $HOME/bin/$file to $DIR/bin/$file"
	ln -s $DIR/$file $HOME/bin/$file
done

tmux source-file ~/.tmux.conf
tmux refresh-client -S
