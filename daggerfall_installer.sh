#!/bin/bash

#Created for users who don't know how to setup Daggerfall, Enjoy!
clear
echo "Welcome to the Daggerfall Auto Installe for Ubuntu 16.04 LTS (Only tested on Ubuntu 16.04 LTS, should work with most linux distros)"
echo "This script will automate installing Dosbox, Downloading and Unzipping Daggerfall."
echo -e "\n"
echo "It will then setup a dosgames directory and run the installer in dosbox. Make sure"
echo "to change the installation type to HUGE and when you setup your sound card you click"
echo "Auto Detect, Detect, Test, Ok, then Ok. Write this down I can't automate these parts."
echo -e "\n"
echo "Next the game will start, click exit then it will begin patching Daggerfall."
echo "Keep clicking yes then dosbox will close itself. There should be a desktop launcher that starts"
echo "The game automatically."
echo -n "Click Enter to continue"
read derp

sudo apt-get update

#Check to see if Dosbox is installed
status=$(dpkg -s dosbox|grep installed)
status2=$(dpkg -s imagemagick|grep installed)
clear
echo "Checking to see if Dosbox is installed"
if [ "" == "$status" ];
then
	echo "Dosbox is not installed, this is required so a DOS enviroment";
	echo "can be emulated and Daggerfall can be ran within."
	echo "-------------------------------------------------------------"
	echo -n "Would you like to install Dosbox [Y/N]> "
	read response
	if [[ "$response" =~ y ]];
	then
		echo "Starting installation of Dosbox"
		sudo apt-get install dosbox
		echo "Dosbox installation complete."
	fi
else
	echo "Dosbox is already installed."
fi

#Create dosgames directory
echo "Creating directory to house dosbox games"
mkdir "$HOME/dosgames"
echo "$HOME/dosgames created"

#Download Daggerfall, Unpack, start mounting of DFCD and Daggerfall, Create custom dosbox configs, and run dosbox with installation config 
install_dagger(){
	cd "$HOME/dosgames"
	echo "Downloading Daggerfall in 5 seconds"
	sleep 5
	wget https://cdnstatic.bethsoft.com/elderscrolls.com/assets/files/tes/extras/DFInstall.zip
	echo "Unzipping Daggerfall"
	sleep 2
	unzip DFInstall.zip
	echo "Creating Daggerfall and Daggerfall_Install dosbox configuration"
	cd "$HOME/.dosbox"
	cp dosbox-0.74.conf daggerfall_install.conf
	cp daggerfall_install.conf daggerfall.conf
	echo "mount c $HOME/dosgames -freesize 1000" >> daggerfall_install.conf
	echo "mount d $HOME/dosgames/DFCD -t cdrom -label Daggerfall" >> daggerfall_install.conf
	echo "d:" >> daggerfall_install.conf
	echo "INSTALL" >> daggerfall_install.conf
	echo "fall z.cfg" >> daggerfall_install.conf
	echo "DAG213" >> daggerfall_install.conf
	echo "exit" >> daggerfall_install.conf

	echo "mount c $HOME/dosgames" >> daggerfall.conf
	echo "c:" >> daggerfall.conf
	echo "cd DAGGER" >> daggerfall.conf
	echo "fall z.cfg" >> daggerfall.conf
	echo "exit" >> daggerfall.conf
	clear
	echo "Remember to change the Installation size to Huge, and when asked to setup your sound card"
	echo "To click Auto-Detect, then Detect, Then Test, Then Ok, Then Ok again, Write this down if you need"
	echo "to refer back to these instructions."
	echo -e "\n"
	echo "After the installation is complete the game will start, make sure to exit and let the script finish patching the game."
	echo "When the script has ran look, on your desktop for your shiny new Daggerfall. Enjoy the game as much as I have."
	echo -e "\n"
	echo "- BrianMiltonJr A.K.A(JohnWillikers)"
	echo -e "\n"
	echo -n "Press Enter to Continue after reading the instructions above"
	read derp
	dosbox -conf "$HOME/.dosbox/daggerfall_install.conf"
}

install_dagger

#Create Desktop Launcher
file="$HOME/Desktop/The Elder Scrolls II: Daggerfall.desktop"
echo "[Desktop Entry]" > "$file"
echo "Version=1.0" >> "$file"
echo "Type=Application" >> "$file"
echo "Comment=Starts Daggerfall in Dosbox" >> "$file"
echo "Terminal=true" >> "$file"
echo "Exec=dosbox -conf '$HOME/.dosbox/daggerfall.conf' -fullscreen" >> "$file"
echo "Name=The Elder Scrolls II: Daggerfall" >> "$file"
echo "Icon=$HOME/dosgames/DAGGER/DAGGER.ICO" >> "$file"
sudo chmod +x "$file"
