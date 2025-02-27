#include <stdio.h>
int foo(void);
int main(void) {
    printf("test\n");
    return (foo() == 42) ? 0 : -1;
}
