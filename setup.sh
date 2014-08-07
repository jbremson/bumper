#!/bin/sh

cp ./bmp_src ~/.bmp_src

# Edit .bashrc to load bmp_src, but only do it 
# if it is not already there.

val=`grep 'source ~/.bmp_src' ~/.bashrc`
if [ -z "$val" ]; then
	echo "source ~/.bmp_src" >> ~/.bashrc
fi
