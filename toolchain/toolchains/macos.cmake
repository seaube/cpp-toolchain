string(REGEX REPLACE "^([^-]+)-.*" "\\1" CPU_ARCH "@host_triple@")

set(CMAKE_OSX_ARCHITECTURES ${CPU_ARCH})
set(CMAKE_OSX_SYSROOT "macosx")

if(CPU_ARCH STREQUAL "arm64")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0")
else()
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13")
endif()
