#include <stdio.h>
#include <string.h>

// exploit me with 140 buffer length. 136 bytes as payload and last 4 bytes
// overwrites EIP
int function(char *a) {
  char buf[128];

  strcpy(buf, a);
  __asm__("jmp *%esp");

  return 0;
}


int main(int argc, char **argv) {
  FILE *fp;
  char buf[4096];

  fp = fopen("./pwnme.txt", "r");
  fread(buf, sizeof(char), 4096, fp);
  printf("%s\n", buf);

  return function(buf);
}
