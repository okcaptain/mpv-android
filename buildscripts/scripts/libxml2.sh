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

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

../autogen.sh \
	--host=$ndk_triple --without-python

make -j$cores
make DESTDIR="$prefix_dir" install