#!/usr/bin/env bash

# Use privileged mode, to e.g. ignore $CDPATH.
set -p

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit

# nvim -Nu <(cat << EOF
# filetype off
# set rtp+=~/.vim/bundle/vader.vim
# set rtp+=~/.vim/bundle/vim-markdown
# set rtp+=~/.vim/bundle/vim-markdown/after
# filetype plugin indent on
# syntax enable
# EOF) +Vader*

nvim -Nu <(cat <<VIMRC
    filetype off
    set shiftwidth=4

    call plug#begin('~/nvim/plugged')
        Plug 'junegunn/vader.vim'
    call plug#end()

    runtime vim-php-arguments-splitter/plugin/vim-php-arguments-splitter.vim

    filetype plugin indent on
    syntax enable
VIMRC
) -c 'Vader! tests/*.vader' > /dev/null
# ) -c 'Vader! tests/*' > /dev/null

# nvim '+Vader! tests/*' && echo Success || echo Failure