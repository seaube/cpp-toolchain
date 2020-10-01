LLVM_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/llvm-project-10.0.1.tar.xz
CT_NG_URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz

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

x86_64-pc-linux-gnu: x86_64.config ct-ng
	mkdir $@
	cp $< $@/.config
	cd $@ && ${CURDIR}/ct-ng/bin/ct-ng build

aarch64-pc-linux-gnu: aarch64.config ct-ng
	mkdir $@
	cp $< $@/.config
	cd $@ && ${CURDIR}/ct-ng/bin/ct-ng build

llvm/build: x86_64-pc-linux-gnu llvm-project
	mkdir -p $@
	cd $@ && PATH=${PATH}:${CURDIR}/toolchain/bin cmake ${CURDIR}/llvm-project/llvm \
		-DCMAKE_C_COMPILER=x86_64-pc-linux-gnu-gcc \
		-DCMAKE_CXX_COMPILER=x86_64-pc-linux-gnu-g++ \
		-DLLVM_ENABLE_PROJECTS="clang;lld" \
		-DLLVM_TARGETS_TO_BUILD="X86;ARM;AArch64" \
		-DLLVM_ENABLE_ZLIB=ON \
		-DCMAKE_BUILD_TYPE=Release
	cmake --build $@

toolchain/gcc: x86_64-pc-linux-gnu aarch64-pc-linux-gnu
	mkdir -p $@
	cp -r x86_64-pc-linux-gnu/toolchain $@/x86_64-pc-linux-gnu
	cp -r aarch64-pc-linux-gnu/toolchain $@/aarch64-pc-linux-gnu

toolchain/llvm: llvm/build
	mkdir -p $@
	cd $< && cmake -DCMAKE_INSTALL_PREFIX=${CURDIR}/$@ -P cmake_install.cmake

toolchain/bin: portable-toolchain.sh
	mkdir -p $@
	cp $< $@/$<
	ln -sf $< $@/x86_64-pc-linux-gnu-c++
	ln -sf $< $@/aarch64-pc-linux-gnu-c++

toolchain: toolchain/gcc toolchain/llvm toolchain/bin
