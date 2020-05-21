#!/bin/sh

dirname=$(dirname -- "$1")
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"

OBJDUMP=`which objdump`


if ! [ -x $OBJDUMP ]; then
	echo "[!] there is no objdump installed on the system. I can't continue."
	exit 1
fi

$OBJDUMP -d $dirname/$filename |grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-7 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
