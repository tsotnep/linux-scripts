# @author: Tsotnep

# name
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

# get current Resolution
R=$(xrandr | grep "\*")

# get X and Y
R=$(echo $R | tr x ' ')
X=$(echo $R | cut -d ' ' -f1)
Y=$(echo $R | cut -d ' ' -f2)

# get values for --panning
sXfloat=$(echo "$X * $SCALE" | bc)
sYfloat=$(echo "$Y * $SCALE" | bc)
sX=${sXfloat%.*}
sY=${sYfloat%.*}

# get the name of connected screen
connectedScreen=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

# set the resolution and panning
xrandr --output $connectedScreen --scale "$SCALE"x"$SCALE" --panning "$sX"x"$sY"
