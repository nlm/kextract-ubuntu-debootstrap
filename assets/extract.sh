#!/bin/sh -eu

echo_info()
{
    echo "[+] $*"
}

echo_subinfo()
{
    echo "    $*"
}

usage()
{
    echo "usage: $0 ARCH DIST"
}

if [ "$#" -ne 2 ]
then
    usage
    exit 1
fi

UBUNTU_ARCH="${1}"
UBUNTU_DIST="${2}"

kernel_version=$(ls /lib/modules)
echo "Archiving kernel..."
cp "/boot/vmlinuz-${kernel_version}" "/workdir/vmlinuz-${UBUNTU_ARCH}-${UBUNTU_DIST}"
rm -f "/workdir/modules-${UBUNTU_ARCH}-${UBUNTU_DIST}.tar.gz"
echo "Archiving modules..."
tar -C "/lib/modules" -zcf "/workdir/modules-${UBUNTU_ARCH}-${UBUNTU_DIST}.tar.gz" "${kernel_version}"
rm -f "/workdir/firmware-${UBUNTU_ARCH}-${UBUNTU_DIST}.tar.gz"
echo "Archiving firmware..."
tar -C "/lib/firmware" -zcf "/workdir/firmware-${UBUNTU_ARCH}-${UBUNTU_DIST}.tar.gz" "${kernel_version}"
