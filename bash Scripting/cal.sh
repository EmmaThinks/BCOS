#!/bin/bash

# cal is a command made to compile and link .asm files turning them into simple binary files, it can be handy for tests or small files i will maybe make it a little bit
# more complex if i need to

VAR=0

for arg in "$@"; do
  nasm -f elf64 -o "${arg%%.*}".o "$arg" || { echo "command NASM failed or not found"; exit 1; }
  gcc -o "${arg%%.*}" "${arg%%.*}".o -no-pie -nostdlib || { echo "command gcc failed or not found"; exit 1; }
  rm "${arg%%.*}".o
  ((VAR++))
done

echo "A total of $VAR files were changed to binary";
