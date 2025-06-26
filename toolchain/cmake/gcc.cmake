set(CT_NG_SOURCE_DIR ${SOURCE_DIR}/crosstool-ng)
set(CT_NG_BUILD_DIR ${BUILD_DIR}/crosstool-ng)
set(CT_NG ${CT_NG_BUILD_DIR}/bin/ct-ng)

ExternalProject_Add(crosstool-ng
    GIT_REPOSITORY https://github.com/crosstool-ng/crosstool-ng.git
    GIT_TAG 1e9bf8151513b054f60f34bc89507c31dc242cf0
    UPDATE_COMMAND ""
    SOURCE_DIR ${CT_NG_SOURCE_DIR}
    CONFIGURE_COMMAND
        ./bootstrap && ./configure --prefix=${CT_NG_BUILD_DIR}
    BUILD_COMMAND
        make -j${CMAKE_BUILD_PARALLEL_LEVEL}
    INSTALL_COMMAND 
        make install
    BUILD_IN_SOURCE TRUE
)

# Build crosstool-ng toolchains
function(build_crosstool_ng_toolchain TARGET_ARCH)
    ExternalProject_Add(gcc-toolchain-${TARGET_ARCH}
        DEPENDS crosstool-ng
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/targets/${TARGET_ARCH}
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND
            ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/targets/${TARGET_ARCH}/defconfig ${BUILD_DIR}/gcc/${TARGET_ARCH}/defconfig && 
            ${CMAKE_COMMAND} -E chdir ${BUILD_DIR}/gcc/${TARGET_ARCH} ${CT_NG} defconfig
        BUILD_COMMAND
            ${CMAKE_COMMAND} -E chdir ${BUILD_DIR}/gcc/${TARGET_ARCH}
            ${CMAKE_COMMAND} -E env --unset=LD_LIBRARY_PATH
            ${CT_NG} build
        INSTALL_COMMAND ""
        BUILD_IN_SOURCE FALSE
    )
endfunction()

# Build all crosstool-ng toolchains
foreach(TARGET IN LISTS TOOLCHAIN_TARGETS)
    build_crosstool_ng_toolchain(${TARGET})
endforeach()
