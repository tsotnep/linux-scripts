# @author: Tsotnep

# description
  # this script, is for changing resolution on linux Mint, Ubuntu and probably many others
  # commands used/needed: xrandr, grep, cut, bc

# manual:
  # if current resolution is 1366x768 and scale is 1.2, new resolution will be: 1639x921
  # there should be only one screen connected

# examples
  # bash screen.sh       # default is 1.2
  # bash screen.sh 1.5   # or you can specify scale value
  # bash screen.sh 1     # and '1' for default scale

# receive SCALE variable from user, you can change "1.2" into other default value
SCALE=${1:-"1.2"}

# get the name of connected screen
connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
activeOutput=($(xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/"))
echo ${activeOutput[*]}
read -p "Type number of screen from the list above, you want to change 0,1,2.. : " resp
scrN=${activeOutput[$resp]}
# scrR=
# echo $scrN
# get current Resolution
Resolutions=($(xrandr | grep "\*"))

# echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
Res=()
for i in "${Resolutions[@]}"
do
    if [[ "$i" == *"x"* ]] ; then
        # echo "FOUNDDDDDDDDDD"
        # echo $i
        Res+=($i)
    fi
done
# echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

# echo ${Res[*]}

R=${Res[$resp]}
# echo "R is " $R

# get X and Y
R=$(echo $R | tr x ' ')
# echo "R is " $R
X=$(echo $R | cut -d ' ' -f1)
# echo "X is " $X
Y=$(echo $R | cut -d ' ' -f2)
# echo "Y is " $Y

# get values for --panning
sXfloat=$(echo "$X * $SCALE" | bc)
sYfloat=$(echo "$Y * $SCALE" | bc)
sX=${sXfloat%.*}
sY=${sYfloat%.*}
# echo "sX is " $sX
# echo "sY is " $sY

# TODO: when several monitors are conected, pixel starting and ending points needs to be fixed
  # when u type xrandr, it prints ...1639x921+0+0... here, 0+0 is xy of pixel starting points, so when there are several screens,
  # they should be modified correctly, otherwise it fuckes up

# set the resolution and panning
xrandr --output $scrN --scale "$SCALE"x"$SCALE" --panning "$sX"x"$sY"

#other commands :
#$ xdpyinfo  | grep dimensions    # to see the actual values of current resolution
