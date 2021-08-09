cd ..
mkdir dist
cd build
nim c -o:../dist/build.o -r build.nim
cd ..
cd dist
clear
./build.o ${1}