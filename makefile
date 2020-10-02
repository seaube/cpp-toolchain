LLVM_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/llvm-project-10.0.1.tar.xz
CT_NG_URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz
ZLIB_URL=https://www.zlib.net/fossils/zlib-1.2.7.3.tar.gz

X86_TARGET=x86_64-pc-linux-gnu
AARCH64_TARGET=aarch64-unknown-linux-gnu

.PHONY: all

all: toolchain



llvm-archive: 
	curl -L ${LLVM_URL} --output $@

llvm-project: llvm-archive
	mkdir $@
	tar -xf $< -C $@ --strip-components=1


ct-ng-archive:
	curl -L ${CT_NG_URL} --output $@

ct-ng-src: ct-ng-archive
	mkdir $@
	tar -xf $< -C $@ --strip-components=1

ct-ng: ct-ng-src
	mkdir $@
	cd $< && ./configure --prefix=${CURDIR}/$@
	make -C $< && make -C $< install



zlib-archive:
	curl -L ${ZLIB_URL} --output $@

zlib-src: zlib-archive
	mkdir $@
	tar -xf $< -C $@ --strip-components=1

${X86_TARGET}/zlib: zlib-src ${X86_TARGET}
	mkdir $@
	cd $@ && PATH=${CURDIR}/${X86_TARGET}/toolchain/bin:${PATH} cmake ${CURDIR}/zlib-src \
		-DCMAKE_C_COMPILER=${X86_TARGET}-gcc \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_BUILD_TYPE=Release
	cmake --build $@

${AARCH64_TARGET}/zlib: zlib-src ${AARCH64_TARGET}
	mkdir $@
	cd $@ && PATH=${CURDIR}/${AARCH64_TARGET}/toolchain/bin:${PATH} cmake ${CURDIR}/zlib-src \
		-DCMAKE_C_COMPILER=${AARCH64_TARGET}-gcc \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_BUILD_TYPE=Release
	cmake --build $@



${X86_TARGET}: x86_64.config ct-ng
	mkdir $@
	cp $< $@/.config
	cd $@ && ${CURDIR}/ct-ng/bin/ct-ng build

${AARCH64_TARGET}: aarch64.config ct-ng
	mkdir $@
	cp $< $@/.config
	cd $@ && ${CURDIR}/ct-ng/bin/ct-ng build

llvm: toolchain/gcc llvm-project
	mkdir $@
	cd $@ && PATH=${PATH}:${CURDIR}/toolchain/gcc/${X86_TARGET}/bin cmake ${CURDIR}/llvm-project/llvm \
		-DCMAKE_C_COMPILER=${X86_TARGET}-gcc \
		-DCMAKE_CXX_COMPILER=${X86_TARGET}-g++ \
		-DLLVM_ENABLE_PROJECTS="clang;lld" \
		-DLLVM_TARGETS_TO_BUILD="X86;ARM;AArch64" \
		-DLLVM_ENABLE_ZLIB=ON \
		-DCMAKE_BUILD_TYPE=Release
	cmake --build $@ -- -j4

toolchain/gcc: ${X86_TARGET}/zlib ${AARCH64_TARGET}/zlib
	mkdir -p $@
	cp -r ${X86_TARGET}/toolchain $@/${X86_TARGET}
	cp -r ${AARCH64_TARGET}/toolchain $@/${AARCH64_TARGET}
	cd ${X86_TARGET}/zlib && make DESTDIR=${CURDIR}/$@/${X86_TARGET}/${X86_TARGET}/sysroot install
	cd ${AARCH64_TARGET}/zlib && make DESTDIR=${CURDIR}/$@/${AARCH64_TARGET}/${AARCH64_TARGET}/sysroot install

toolchain/llvm: llvm
	mkdir -p $@
	cd $< && cmake -DCMAKE_INSTALL_PREFIX=${CURDIR}/$@ -P cmake_install.cmake

toolchain/scripts: tools.sh
	mkdir -p $@
	cp $< $@/$<

toolchain/bin: toolchain/scripts
	mkdir -p $@
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-cc
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-c++
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-ld
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-ar
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-as
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-ranlib
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-strip
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-size
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-nm
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-objcopy
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-objdump
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-c++filt
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-addr2line
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-strings
	ln -sf ../scripts/tools.sh $@/${X86_TARGET}-readelf
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-cc
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-c++
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-ld
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-ar
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-as
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-ranlib
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-strip
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-size
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-nm
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-objcopy
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-objdump
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-c++filt
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-addr2line
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-strings
	ln -sf ../scripts/tools.sh $@/${AARCH64_TARGET}-readelf
	ln -sf ../llvm/bin/clang-format $@/clang-format

toolchain: toolchain/gcc toolchain/llvm toolchain/bin
