#! /bin/sh
nvim --headless -R "$@" +'runtime scripts/catcolored.vim' +'q!'
