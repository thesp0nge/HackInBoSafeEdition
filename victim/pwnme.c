#include <stdio.h>
#include <string.h>

int foobar() {
  __asm__("jmp *%esp");
}
// exploit me with 140 buffer length. 136 bytes as payload and last 4 bytes
// overwrites EIP
int function(char *a) {
  //char buf[120];
  char buf [60];

  int b=5;


  for (int i=0; i<50; i++){
    b*=b;
  }

  printf("The amount of money is %d\n", b);
  strcpy(buf, a);
  
  for (int i=0; i<50; i++){
    b*=b;
  }

  printf("The amount of money is %d\n", b);

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
