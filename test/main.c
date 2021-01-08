#include <stdio.h>
int foo();
int main() {
    printf("test");
    return (foo() == 42) ? 0 : -1;
}
