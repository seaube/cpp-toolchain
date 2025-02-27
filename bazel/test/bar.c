#ifdef __linux__
#include <omp.h> // make sure we have extra runtime libs
#endif

int bar(void) { return 42; }
