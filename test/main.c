#include <stdio.h>
int foo(void);
int main(void) {
    printf("test");
    return (foo() == 42) ? 0 : -1;
}
