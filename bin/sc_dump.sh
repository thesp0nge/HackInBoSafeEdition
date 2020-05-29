#!/bin/sh


OBJDUMP=`which objdump`
FORMAT="py"

version() {
    print "1.0"
}

usage() {
    echo -e "Usage: $0 [-r]\n\n\t-r: prints the shellcode as a raw bytes sequence" 1>&2
}

while getopts "rvh" options; do
  case "${options}" in
    r)
      FORMAT="raw"
      ;;
    v)
      version()
      exit 0
      ;;
    h)
      usage()
      exit 0
      ;;
  esac
done
shift $((OPTIND-1))
dirname=$(dirname -- "$1")
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"

if ! [ -x $OBJDUMP ]; then
  echo "[!] there is no objdump installed on the system. I can't continue."
  exit 1
fi

if [ $FORMAT = "raw" ]; then
  $OBJDUMP -d $dirname/$filename |grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-7 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'| tr -d "\n" | tr -d " "
else
  $OBJDUMP -d $dirname/$filename |grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-7 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'
fi

