LLVM_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/llvm-project-10.0.1.tar.xz
CT_NG_URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz

.PHONY: all

all: ct-ng-build/toolchains/x86_64-linux-gnu

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

ct-ng-build/toolchains/x86_64-linux-gnu: ct-ng-build/x86_64.config ct-ng
	cp $< ct-ng-build/.config
	ct-ng/bin/ct-ng build

# the stage1 libs are built against musl using the stage0 compiler
stage0: llvm-project sysroot0
	mkdir $@
	cd $@ && cmake ../$</llvm \
		-DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_CXX_FLAGS="-nobuiltininc -nostdinc++ --sysroot=${CURDIR}/sysroot0 --prefix=/usr/lib/gcc/x86_64-redhat-linux/4.4.4/ -iwithsysroot=/opt/rh/devtoolset-9/root/usr/include/c++/9" \
		-DLLVM_ENABLE_PROJECTS="libcxx" \
		-DLIBUNWIND_ENABLE_SHARED=OFF \
		-DLIBUNWIND_ENABLE_STATIC=ON \
		-DLIBUNWIND_USE_COMPILER_RT=ON \
		-DLIBUNWIND_HERMETIC_STATIC_LIBRARY=ON \
		-DLIBCXX_ENABLE_SHARED=OFF \
		-DLIBCXX_ENABLE_STATIC=ON \
		-DLIBCXX_HERMETIC_STATIC_LIBRARY=ON \
		-DLIBCXX_USE_COMPILER_RT=ON \
		-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
		-DLIBCXXABI_USE_LLVM_UNWINDER=ON \
		-DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
		-DLIBCXXABI_USE_COMPILER_RT=ON \
		-DLIBCXXABI_HERMETIC_STATIC_LIBRARY=ON
	cmake --build $@

stage0/root: stage0
	cd stage0 && cmake -DCMAKE_INSTALL_PREFIX=${CURDIR}/$@ -P cmake_install.cmake

sysroot: stage1/root musl-host
	mkdir $@
	cp -r musl-host/root/lib $@/lib
	cp -r musl-host/root/include $@/include
	cp stage0/root/lib/libc++.a stage0/root/lib/libc++abi.a stage0/root/lib/libunwind.a $@/lib
	cp -r stage0/root/lib/clang $@/lib
	cp -r stage0/root/include/c++ $@/include

clean:
	rm -f llvm-archive
	rm -rf llvm-project stage0
