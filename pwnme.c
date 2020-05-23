#include <stdio.h>
#include <string.h>

// exploit me with 140 buffer length. 136 bytes as payload and last 4 bytes
// overwrites EIP
int function(char **argv) {
  char buf[128];

  strcpy(buf, argv[1]);

  return 0;
}

int main(int argc, char **argv) {
  return function(argv);
}
