cd ..
mkdir dist
cd test
nim c -o:../dist/test.o -r test.nim
cd ..
cd dist
clear
./test.o