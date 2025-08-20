# make-q68-image
A script to build SD card images for the Q68 and QL-SD devices.

## Requirements

For this script to run you need the guestfish command from the
guestfs-tools package (naming may vary on your distro of choice)

## Usage

```
make-q68-image.sh
Usage: make-q68-image.sh <SIZE> <IMAGE> <DIRECTORY>
```

SIZE is the size of the image, you can use M and G units eg.
1000M or 1G.

IMAGE is the output file.

DIRECTORY contains the files which will be put into the image,
normally QXL.WIN or QWLA.WIN files. Filenames are not translated
so make sure they are Q68 and QL-SD compliant.

## Example Run

```
make-q68-image.sh 1G qlsd-blank.img qlsd-blank/
Collecting files
./
./QXL.WIN
Creating images
Cleanup
```
