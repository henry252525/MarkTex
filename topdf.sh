#! /bin/bash
BUILD_DIR=build

if [ $# -eq 0 ]
  then
  echo "No arguments supplied"
  exit 1
fi

name=${1%.*}

mkdir -p $BUILD_DIR

rm $BUILD_DIR/$name.aux $BUILD_DIR/$name.log $BUILD_DIR/$name.out &> /dev/null

./marktex.sh $1 | pdflatex -jobname=$name -output-directory $BUILD_DIR > /dev/null && open $BUILD_DIR/$name.pdf
