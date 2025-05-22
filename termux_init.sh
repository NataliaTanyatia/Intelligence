#!/bin/bash
# Termux environment preparation
pkg update -y
pkg install -y python nodejs clang
python -m ensurepip --upgrade
pip install wheel

# Fix library paths
export LD_LIBRARY_PATH=$PREFIX/lib
export CFLAGS="-I$PREFIX/include"
