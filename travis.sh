#!/bin/sh

for dist in xenial
do
  for arch in amd64 arm64
  do
    ./run.sh $arch $dist
  done
done
