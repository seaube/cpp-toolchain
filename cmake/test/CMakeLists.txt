project(Test)

add_library(LibStatic STATIC lib.cpp lib.c)
add_library(LibShared SHARED lib.cpp lib.c)
add_executable(ExeStatic main.cpp)
add_executable(ExeShared main.cpp)
target_link_libraries(ExeStatic PRIVATE LibStatic)
target_link_libraries(ExeShared PRIVATE LibShared)
