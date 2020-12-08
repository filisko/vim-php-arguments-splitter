#!/usr/bin/env bash

# Use privileged mode, to e.g. ignore $CDPATH.
set -p

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit

test_file=${1}

if [[ ! -f "$test_file" ]]; then
	echo "specify a test file"
	exit 1
fi

declare -a binaries=("nvim" "mvim" "vim")

VIM="vim"
for binary in "${binaries[@]}"; do
	if command -v $binary &> /dev/null; then
		VIM=$binary
		break
	fi
done

eval "$VIM -Nu vimrc -c 'Vader! $test_file'" > /dev/null
