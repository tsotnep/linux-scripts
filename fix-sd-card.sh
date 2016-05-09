##SD-CARD fixing errors:

sudo fsck.msdos -a /dev/mmcblk0p1 
#a=allSD-CARD formatting:

sudo mkfs.vfat -n ZED_BOOT /dev/mmcblk0p1 
#n=name


