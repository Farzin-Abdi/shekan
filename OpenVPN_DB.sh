#! /bin/bash
clear
FILE=/usr/local/bin/shekan
if test -f "$FILE"; then
    echo "$FILE exists."
else
ScriptLoc=$(readlink -f "$0")
sudo cp $ScriptLoc /usr/local/bin/shekan
sudo chmod +x /usr/local/bin/shekan
echo -e "Note: You can use 'shekan' command in terminal to start this tool."
sleep 5
fi
package='openvpn3'
if ! command -v $package &> /dev/null
then
echo -e "***** This Script is for Installing and Connecting to OpenVpn *****"
echo -e "Enter The Number For Selecting Installation Server:\n\n  Defualt Installation \n **IMPORTANT** Connect VPN or Proxy before Installation in banned countries to install properly\n "
sleep 3
user='https://swupdate.openvpn.net'
fi
if ! command -v $package &> /dev/null
then
    echo -e "Installing OpenVpn3............\n\n"
    yes | sudo apt install apt-transport-https
    sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub
    sudo apt-key add openvpn-repo-pkg-key.pub
    clear
    echo -e " Select your Linux Distribution:\n"
    echo -e " 1:Debian 9\n 2:Debian 10\n 3:Ubuntu 16.04\n 4:Ubuntu 18.04\n 5:Ubuntu 19.10\n 6:Ubuntu 20.04\n"
    read -p " Select: " useros
    if [[ $useros == '1' ]];then
    DISTRO='stretch'
    elif [[ $useros == '2' ]];then
    DISTRO='buster'
    elif [[ $useros == '3' ]];then
    DISTRO='xenial'
    elif [[ $useros == '4' ]];then
    DISTRO='bionic'
    elif [[ $useros == '5' ]];then
    DISTRO='eoan'
    elif [[ $useros == '6' ]];then
    DISTRO='focal'
    fi
    echo $DISTRO
    sudo wget -O /etc/apt/sources.list.d/openvpn3.list https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-$DISTRO.list
    sudo apt-get update
    sudo apt install openvpn3
fi
#clear
nol=$(openvpn3 sessions-list | awk 'NR==7{print $5}')
nol2=$(openvpn3 sessions-list | awk 'NR==7{print $4}')
if [[ $nol2 == 'connected' ]];then
    colorsh=2
    statussh="CONNECTED"
elif [[ $nol == 'paused' ]];then
    colorsh=3
    statussh="PAUSED"
else
    colorsh=1
    statussh="NOT CONNECTED"
fi
clear
echo
tput setaf $colorsh && echo -e "    *******      *                   *"                              
tput setaf $colorsh && echo -e "    *       ***  **                  **"                              
tput setaf $colorsh && echo -e "   *         **  **                  **"                               
tput setaf $colorsh && echo -e "   **        *   **                  **"                               
tput setaf $colorsh && echo -e "    ***          **                  **"                               
tput setaf $colorsh && echo -e "   ** ***        **  ***      ***    **  ***      ****   ***  ****"    
tput setaf $colorsh && echo -e "    *** ***      ** * ***    * ***   ** * ***    * ***  * **** **** "
tput setaf $colorsh && echo -e "      *** ***    ***   ***  *   ***  ***   *    *   ****   **   ****"  
tput setaf $colorsh && echo -e "        *** ***  **     ** **    *** **   *    **    **    **    **"   
tput setaf $colorsh && echo -e "          ** *** **     ** ********  **  *     **    **    **    **"   
tput setaf $colorsh && echo -e "           ** ** **     ** *******   ** **     **    **    **    **"   
tput setaf $colorsh && echo -e "            * *  **     ** **        ******    **    **    **    **"   
tput setaf $colorsh && echo -e "  ***        *   **     ** ****    * **  ***   **    **    **    **"   
tput setaf $colorsh && echo -e " *  *********    **     **  *******  **   *** * ***** **   ***   ***"  
tput setaf $colorsh && echo -e "*     *****       **    **   *****    **   ***   ***   **   ***   ***" 
tput setaf $colorsh && echo -e "*                       *                                             "
tput setaf $colorsh && echo -e " **                    *                                              "
tput setaf $colorsh && echo -e "                      *                                               "
tput setaf $colorsh && echo -e "                     *                       "
tput sgr0
echo
echo -n "  << Status: " && tput setaf $colorsh && echo -n $statussh && tput sgr0 && echo  " >>"
echo
echo -e "Select OpenVpn Option:"
echo
echo -e " 1  >>  Connect using OpenVpn profile"
echo -e " 2  >>  Pause the OpenVpn"
echo -e " 3  >>  Disonnect the OpenVpn"
echo -e " 4  >>  Get OpenVpn Status"
echo -e " 5  >>  Manage Profiles"
echo -e " *  >>  Exit\n"
read -p "Select: " userinss
#confloc=$(<shekantel.ovpn)
if [[ $userinss == '1' ]];then
echo
cat -n openpro
echo
nopro=$(cat -n openpro | wc -l)
if [[ $nopro == '0' ]];then
echo "Select 5 to Add a Profile"
sleep 3
clear
ScriptLoc=$(readlink -f "$0")
bash  "$ScriptLoc"
exit
fi
read -p "Select a profile to connect: " usermanagecon
confloc=$(awk '{if(NR=='$usermanagecon') print $1}' openpro)
nol=$(openvpn3 sessions-list | awk '{ print  }' | wc -l)
if [[ $nol == '1' ]];then
echo "Starting Session"
openproid=$(openvpn3 sessions-list | awk 'NR==2{print $2}')
openvpn3 session-start --config $confloc
else
echo "Restarting Session"
openproid=$(openvpn3 sessions-list | awk 'NR==2{print $2}')
openvpn3 session-manage --session-path $openproid --disconnect
openvpn3 session-start --config $confloc
fi
sleep 2
ScriptLoc=$(readlink -f "$0")
bash  "$ScriptLoc"
elif [[ $userinss == '2' ]];then
echo "Pause it:"
openproid=$(openvpn3 sessions-list | awk 'NR==2{print $2}')
openvpn3 session-manage --session-path $openproid --pause
sleep 2
ScriptLoc=$(readlink -f "$0")
bash  "$ScriptLoc"
elif [[ $userinss == '3' ]];then
echo "Disconnect it:"
openproid=$(openvpn3 sessions-list | awk 'NR==2{print $2}')
openvpn3 session-manage --session-path $openproid --disconnect
sleep 2
ScriptLoc=$(readlink -f "$0")
bash  "$ScriptLoc"
elif [[ $userinss == '4' ]];then
echo -e "Status will remain for 6 second"
openvpn3 sessions-list
sleep 6
ScriptLoc=$(readlink -f "$0")
bash  "$ScriptLoc"

elif [[ $userinss == '5' ]];then
echo -e "\n 1: Add new profile"
echo -e " 2: Delete a profile\n"
read -p "Select: " usermanage
if [[ $usermanage == '1' ]];then
echo -e "Give me Full Location and Filename: "
echo -e "(E.g '/home/user/filename.ovpn')\n"
read -p "get: " userinssloc
if test -f "$userinssloc"; then
fileloc=$userinssloc
echo $fileloc >> openpro
sleep 2
ScriptLoc=$(readlink -f "$0") 
bash  "$ScriptLoc"
else
echo "Error $userinssloc does not exists."
sleep 2
ScriptLoc=$(readlink -f "$0") 
bash  "$ScriptLoc"
fi
elif [[ $usermanage == '2' ]];then
cat -n openpro
read -p "Select a profile to delete: " usermanagedel
sed -i $usermanagedel'd' openpro
sleep 2
ScriptLoc=$(readlink -f "$0") 
bash  "$ScriptLoc"
else
sleep 1
ScriptLoc=$(readlink -f "$0") 
bash  "$ScriptLoc"
fi
elif [[ $userinss == '*' ]];then
trap "exit" INT
while :
do
    exit
done
else
ScriptLoc=$(readlink -f "$0")
bash  "$ScriptLoc"
fi

