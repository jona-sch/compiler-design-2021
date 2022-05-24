#include <stdio.h>
#include <stdlib.h>

int global;
static int stat;
int globalinit = 1;

int sum_n(int n){
  int local_sum = 10;
  printf("Address of local_sum (local in sum_n, initialized, int) is %p\n", &local_sum);
  return (n==1 ? 1 : n + sum_n(n-1));
}

int main(int argc, char* args[]){
  if(argc == 1 || atoi(args[1]) < 1){
	printf("You need to provide a positive number.\n");
	return 0;
  }
  int arg = atoi(args[1]);
  printf("The sum from 1 to %d is %d\n", arg, sum_n(arg));

  int one;
  int two;
  int oneinit = 1;
  printf("Distance between one (%p) and two (%p) is %d\n", &one, &two, sizeof(int)*(&two-&one));
  printf("Local: %p, global: %p, static: %p\n", &arg, &global, &stat); 
  printf("Initalized: %p (global), %p (local)\n", &globalinit, &oneinit);

  return 0;
}
