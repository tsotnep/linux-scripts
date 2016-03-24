#Author: Tsotnep

#how to use, example:
	#  bash doshit.sh led3.c
	#  bash doshit.sh led3

#what it does
	# export xilinx tool path
	# writes makefile with given argument name
	# executes makefile
	# opens new terminal and connects to zedboard with picocom
	# copies the *ko file through UART and names it *.uart.ko
	# removes old module and installs new one (same named)

#how to prepare
	# insert SD card into zedboard with basic files, BOOT.bin, devicetree.dts, zImage, ramdisk8m.image.gz
	# restart zedboard and wait for 10 seconds

#what apps you need : sudo apt-get install *
	# konsole
	# screen
	# xxd 	#it's in every linux by default
	# sed		#it's in every linux by default

#computer depending variables
	#xilinx cross compile toolchain
	XILINXTOOLCHAIN=/opt/Xilinx/SDK/2015.2/gnu/arm/lin/bin/

#note
	# after you finish/stop, make sure all 'screen's are killed






# no need to change
CFILENAME=$1 #first argument
T=T0 #terminal name which will open picocom for zedboard


## functions
screen_enter(){
	screen -S $T -X stuff "$1"`echo -ne '\015'`
}



################################################################
##########################start working#########################

#TODO : if programs are not installed, install them



##### add xilinx garbage to path
export PATH=$PATH:$XILINXTOOLCHAIN



##### extract argument name to be used for Makefile, check if we gave the parameter led3.c OR led3
SIZE=${#CFILENAME} #length of FILENAMEing
if [[ $CFILENAME == *"."* ]]
then
	FILENAME=${CFILENAME:0:SIZE-2} #cut the whole FILENAMEing with '.' and select part 1 -> "$1 | cut -d "." -f 1"
else
	FILENAME=$CFILENAME
fi



###### create makefile
make clean
echo obj-m += $FILENAME.o > Makefile
echo CC='$(CROSS_COMPILE)'gcc >> Makefile
echo -e all: '\n\t'make -C ../linux-digilent/ M='$(PWD)' modules >> Makefile
echo -e '\t''$(CC)' test.c -o test >> Makefile
echo -e clean: '\n\t'make -C ../linux-digilent/ M='$(PWD)' clean >> Makefile
echo -e '\t'rm test >> Makefile


##### buld shits
make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-

read -p "exit=y, continue=n" resp
if [[ $resp == "y" ]]; then
	exit
fi

##### open terminal
konsole -e screen -S $T
sleep 0.5
screen_enter 'echo hello'
screen_enter 'echo if picocom is already open in another terminal, there will be error'
screen_enter 'sudo picocom -b 115200 /dev/ttyACM0'
screen_enter '2'
sleep 1



#TODO if zedboard needs to be restarted, restart and wait


##### mount sd card in case it's not mounted
screen_enter ""
screen_enter "mount /dev/mmcblk0p1 /mnt"
screen_enter "cd /mnt"
screen_enter "touch $FILENAME.ko.hex"
sleep 0.1



##### create text file out of $FILENAME.ko file
xxd -g1 $FILENAME.ko > $FILENAME.ko.hex
sed -i 's/^\(.\)\{9\}//g' $FILENAME.ko.hex
sed -i 's/\(.\)\{16\}$//g' $FILENAME.ko.hex
screen_enter "echo 'hey motherfuckersss'"




# # send lines TODO it's working but copying is not pefect
echo -e -n $FILENAME.ko.hex
while read -r line ; do
	screen_enter "echo $line >> $FILENAME.ko.hex"
  sleep 0.1
done < "$FILENAME.ko.hex"
sleep 0.1



#reconstruction of file
screen_enter "echo 'reconstruction begins now'"
screen -S $T -X stuff "for i in \$(cat $FILENAME.ko.hex) ; do printf \""
screen -S $T -X stuff "\x$"
screen -S $T -X stuff "i\""
screen_enter " ; done > $FILENAME.uart.ko"
sleep 0.1

CHECKSUM=`md5sum $FILENAME.ko`
screen_enter "echo 'original checksum is:'"
screen_enter "echo '$CHECKSUM'"
sleep 0.1

screen_enter "echo 'current checksum is:'"
screen_enter "md5sum $FILENAME.uart.ko"
sleep 0.1

screen_enter "ls -ls"
screen_enter "rmmod $FILENAME"
screen_enter "insmod $FILENAME.uart.ko"
sleep 0.1


echo
echo
echo
##### closing down the opened terminal
read -p "screen -S $T -X kill |or| killall screen |or| y :" resp
if [[ $resp == "y" ]]; then
	screen -S $T -X kill
fi
