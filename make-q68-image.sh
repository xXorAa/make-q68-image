#! /bin/bash

if [[ $# -ne 3 ]]; then
	echo "Usage: make-q68-image.sh <SIZE> <IMAGE> <DIRECTORY>"
	exit 1
fi

SIZE="$1"
IMAGE="$2"
DIR="$3"

truncate -s 4G "$IMAGE"

echo "Collecting files"
(
	cd "$DIR" || exit
	tar cvf "/tmp/$IMAGE.tar" .
)

echo "Creating images"
guestfish <<EOF
add $IMAGE
run
part-init /dev/sda mbr
part-add /dev/sda p 2048 -1
part-set-mbr-id /dev/sda 1 0xc
mkfs vfat /dev/sda1
mount /dev/sda1 /
tar-in /tmp/$IMAGE.tar / 
EOF

echo "Cleanup"
rm "/tmp/$IMAGE.tar"
