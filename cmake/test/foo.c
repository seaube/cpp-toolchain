#include "export.h"

int bar(void);
EXPORT int foo(void) { return bar(); }
