# Author: Hardi Selg
o "Please enter your password"
read -s PASSWORD


mount.cifs //cs05s.intra.ttu.ee/ssz$/tsotne.putkaradze /media/TTY/P/ -o username=tsotne.putkaradze,domain=intra,password=$PASSWORD,uid=tsotne,gid=users
#mount.cifs //cs05s.intra.ttu.ee/ei$/tsotne.putkaradze /media/TTY/H/ -o username=tsotne.putkaradze,domain=intra,password=$PASSWORD,uid=tsotne,gid=users
#mount.cifs //iiah.intra.ttu.ee/material /media/TTY/M/ -o username=tsotne.putkaradze,domain=intra,password=$PASSWORD,uid=tsotne,gid=users
mount.cifs //iiah.intra.ttu.ee/webikodu$/tsotne.putkaradze /media/TTY/W/ -o username=tsotne.putkaradze,domain=intra,password=$PASSWORD,uid=tsotne,gid=users

