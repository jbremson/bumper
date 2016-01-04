#!/bin/sh

cp ./bmp_src.bash ~/.bmp_src
echo ${HOME} > ~/.bmp_persist


val=`grep '#Standard Aliases' ~/.bashrc`
if [ -z "$val"]; then
	cat ./aliases.bash >> ~/.bashrc
fi

# Edit .bashrc to load bmp_src, but only do it 
# if it is not already there.

val=`grep 'source ~/.bmp_src' ~/.bashrc`
if [ -z "$val" ]; then
	echo "source ~/.bmp_src" >> ~/.bashrc
fi

