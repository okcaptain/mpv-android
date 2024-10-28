#!/bin/bash -e

. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	make clean
	exit 0
else
	exit 255
fi
FF_ANDROID_PLATFORM=android-21
FF_ANDROID_ABI=armeabi-v7a
[[ "$ndk_triple" == "aarch64"* ]] && FF_ANDROID_ABI=arm64-v8a
[[ "$ndk_triple" == "x86_64"* ]] && FF_ANDROID_ABI=x86_64
[[ "$ndk_triple" == "i686"* ]] && FF_ANDROID_ABI=x86

CMAKE_EXECUTABLE=$ANDROID_HOME/cmake/3.18.1/bin/cmake

echo $ANDROID_NDK_ROOT
echo $FF_ANDROID_ABI

cat $ANDROID_NDK_ROOT/build/cmake/android-legacy.toolchain.cmake

$CMAKE_EXECUTABLE . \
 -DCMAKE_VERBOSE_MAKEFILE=ON \
 -DCMAKE_ANDROID_ARCH_ABI=$FF_ANDROID_ABI \
 -DANDROID_PLATFORM=$FF_ANDROID_PLATFORM \
 -DANDROID_ARM_NEON=1 \
 -DPROJECT_ABI=$FF_ANDROID_ABI \
 -DANDROID_ABI=$FF_ANDROID_ABI \
 -DANDROID_NDK=$ANDROID_NDK_ROOT \
 -DCMAKE_ANDROID_NDK=$ANDROID_NDK_ROOT \
 -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
 -DCMAKE_INSTALL_PREFIX=$prefix_dir \
 -DBUILD_SHARED_LIBS=1 \
 -DANDROID_USE_LEGACY_TOOLCHAIN_FILE=1 \
 -DCOMPILE_10BIT=1

make -j$cores
make install