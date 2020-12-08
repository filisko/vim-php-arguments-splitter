#!/usr/bin/env bash

# Use privileged mode, to e.g. ignore $CDPATH.
# set -p

# cd "$( dirname "${BASH_SOURCE[0]}" )" || exit

# nvim -Nu <(cat << EOF
# filetype off
# set rtp+=~/.vim/bundle/vader.vim
# set rtp+=~/.vim/bundle/vim-markdown
# set rtp+=~/.vim/bundle/vim-markdown/after
# filetype plugin indent on
# syntax enable
# EOF) +Vader*

# nvim -Nu <(cat <<VIMRC
#     filetype off
#     set shiftwidth=4

#     set rtp+=vader.vim
#     set rtp+=.

#     filetype plugin indent on
#     syntax enable
# VIMRC
# ) -c 'Vader! tests/*.vader' > /dev/null

# Use privileged mode, to e.g. ignore $CDPATH.
set -p

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit


: "${VADER_TEST_VIM:=vim}"
eval "$VADER_TEST_VIM -Nu vimrc -c 'Vader! *'"
