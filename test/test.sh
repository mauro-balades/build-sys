#!usr/bin/env sh

if [ ! ${1} == "--skip"]
then
    cd ..
fi
mkdir dist
cd test
nim c -o:../dist/test.o -r test.nim
cd ..
cd dist
clear
./test.o