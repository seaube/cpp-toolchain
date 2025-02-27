#include <iostream>
extern "C" { int foo(); }
int main() {
    std::cout << "test" << std::endl;
    return (foo() == 42) ? 0 : -1;
}
