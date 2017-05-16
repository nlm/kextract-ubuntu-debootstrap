#!/bin/sh -eu
usage()
{
    echo "usage: $0 amd64|arm64|armel|armhf|i386|powerpc|ppc64el"
}

if [ "$#" -ne 1 -a "$#" -ne 2 ]; then
    usage
    exit 1
fi

DEB_ARCH="${1}"
DI_DIST="${2:-xenial}"

if [ "$DEB_ARCH" = "amd64" ]
then
    UBU_MIRROR="http://archive.ubuntu.com/ubuntu/"
else
    UBU_MIRROR="http://ports.ubuntu.com/"
fi

DOCKERIMAGE="${KEXTRACT_DOCKERIMAGE:-kextract_ubuntu_${DI_DIST}:${DEB_ARCH}}"
WORKDIR="${KEXTRACT_WORKDIR:-$(pwd)/workdir}"

cat Dockerfile.template \
    | sed -e "s/%%DEB_ARCH%%/${DEB_ARCH}/g" \
          -e "s/%%DI_DIST%%/${DI_DIST}/g" \
          -e "s/%%UBU_MIRROR%%/$(echo ${UBU_MIRROR} | sed 's/\//\\\//g')/g" \
    > Dockerfile."${DEB_ARCH}-${DI_DIST}"

# Check dist existence
if ! curl "${UBU_MIRROR}/dists/${DI_DIST}/main/binary-${DEB_ARCH}/Release" -fso /dev/null
then
    echo "error dist"
    exit 1
fi

echo "dist found"

docker build -t "${DOCKERIMAGE}" -f Dockerfile."${DEB_ARCH}-${DI_DIST}" .
docker run --rm -ti -v "${WORKDIR}:/workdir" "${DOCKERIMAGE}" "${DEB_ARCH}" "${DI_DIST}"
