#!/bin/bash

# This is the compile helper. I modified a bit, just
# to detect the file extension and call nasm or gcc
# accordingly.

dirname=$(dirname -- "$1")
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"

echo "[*] Compiling $filename"

if [ "$extension" = "c" ]; then
	echo "[+] Calling gcc without stack protection"
	gcc -g -m32 -fno-stack-protector -z execstack $1 -o $dirname/$filename
fi

if [ "$extension" = "nasm" ]; then

	echo '[+] Assembling with Nasm ... '
	nasm -f elf32 -o $dirname/$filename.o $1

	echo '[+] Linking ...'
	ld -o $dirname/$filename $dirname/$filename.o

	echo '[+] Done!'
fi
