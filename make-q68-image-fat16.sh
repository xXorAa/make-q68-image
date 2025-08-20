#! /bin/bash

if [[ $# -ne 4 ]]; then
  echo "Usage: make-q68-image.sh <SIZE> <IMAGE> <DIRECTORY> <DIRECTORY2>"
  exit 1
fi

SIZE="$1"
IMAGE="$2"
DIR="$3"
DIR2="$4"

truncate -s "$SIZE" "$IMAGE"

img_size=$(stat -c %s "$IMAGE")
img_sectors=$(($img_size / 512))
end_sector=$(($img_sectors - 387072))
start_sector=$(($end_sector + 1))

echo "Collecting files $DIR"
(
  cd "$DIR" || exit
  tar cvf "/tmp/$IMAGE.tar" .
)

echo "Collecting files $DIR2"
(
  cd "$DIR2" || exit
  tar cvf "/tmp/$IMAGE.fat16.tar" .
)

echo "Creating images"
guestfish <<EOF
add $IMAGE
run
part-init /dev/sda mbr
part-add /dev/sda p 2048 $end_sector
part-add /dev/sda p $start_sector -1
part-set-mbr-id /dev/sda 1 0xc
part-set-mbr-id /dev/sda 2 0xc
mkfs vfat /dev/sda1
mkfs vfat /dev/sda2
mount /dev/sda1 /
tar-in /tmp/$IMAGE.tar / 
unmount /dev/sda1
mount /dev/sda2 /
tar-in /tmp/$IMAGE.fat16.tar /
unmount /dev/sda2
EOF

echo "Cleanup"
rm "/tmp/$IMAGE.tar"
