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

./autogen.sh --host=$ndk_triple --enable-static --disable-shared --without-python

make -j$cores
make DESTDIR="$prefix_dir" install