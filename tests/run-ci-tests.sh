#!/usr/bin/env bash

# Use privileged mode, to e.g. ignore $CDPATH.
set -p

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit

export VIM_VERSION=$1

if [ "$VIM_VERSION" = 'neovim' ]; then
	VIM=nvim
elif [ "$VIM_VERSION" = 'macvim' ]; then
	VIM=mvim
else
	VIM=vim
fi

echo 'Vim version'
$VIM --version

: "${VIM:=vim}"
eval "$VIM -Nu vimrc -c 'Vader! *'"
