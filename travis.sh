#!/bin/sh

# Only build tags
if [ -z "$TRAVIS_TAG" ]; then
    echo "Skipping build because this is not a tagged commit"
    exit 0
fi

# Register binfmt_misc hooks
docker run --rm --privileged multiarch/qemu-user-static:register --reset

for dist in xenial
do
  for arch in amd64 arm64
  do
    ./run.sh $arch $dist
  done
done
