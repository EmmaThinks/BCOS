#!/bin/bash

# coal is a command made to compile and link .asm files turning them into simple binary files, it can be handy for tests or small files. i will maybe make it a little bit
# more complex if i need to


# we make sure the user uses the "-f" flag
if [[ "$1" != "-f" ]]; then
  echo "please use the -f flag to insert a file"; exit 1;
fi

#we get the arguments, in this case, we get the file and the type of the file, 
while getopts "f:" opt; do
  case $opt in
    #we get the file and save it in a variable
    f)  file="$OPTARG"
      #we also get the extension to tell the program what  we want to compile
        type="${OPTARG##*.}"
      ;;
      # in case the user puts a flag different from -f
    *) echo "invalid argument -$opt"; exit 1; 
      ;;
  esac
done

# function to compile asm files
function asm {
  nasm -f elf64 -o "${file%%.*}".o "$file" || { echo "command NASM failed or not found"; exit 1; }
  gcc -o "${file%%.*}" "${file%%.*}".o -no-pie -nostdlib || { echo "command gcc failed or not found"; exit 1; }
  rm "${file%%.*}".o
}

# to compile c files
function c {
  gcc "$file" -o "${file%%.*}"
}

# to compile cpp files
function cpp {
  g++ "$file" -o "${file%%.*}"
}

# we get the type and process each case, then each case executes its respective function
case "$type" in
  asm) asm "$file";;
  c) c "$file";;
  cpp) cpp "$file";;

  #if the file has an extension different from the last three ones
  *) echo "file not specified or supported"; exit 1 ;;
esac

# we let the user know that the process finished correctly
echo "$file was compiled as a $type file"
