#! /usr/bin/env bash
#
# Install Klayout & SiEPCI
# Written by Rounak Singh Narde <rn5949@rit.edu>
# MIT License - Public is free to use, distribute and modify
#
# Required: unzip, wget is required. "Everything should be in home directory."
# 
# - script checks for klayout. If not installed, script installs it from the installation zip file.
#
# -Two way installation for SiEPIC - offline and online
# -- offline - installation requires already downloaded zip file. It should be in current directory. 
# The filename should be provided below. The hierarchy should be the same as downloaded from github. 
# -- online - script download zip file from github. A released version number should be provided below.
#
# Note: Script can also be used to update the SiEPIC package directly from github without changing klayout.
# 
#----------------------------------------------------------------------------------------------------------------------

# Klayout file
KLAYOUT_INSTALL_FILE="klayout_RITLinux.zip"

# -offline- SiEPIC_FILE name - if you have a previously downloaded file then write a filename.
# Note the hierarchy of directories should be the same as downloaded from github
SiEPIC_FILE="SiEPIC_EBeam_PDK-0.1.35_RITLinux.zip"

# -online- Enter SiEPIC version as in github releases
SiEPIC_VERSION="0.1.35"

# .bashrc or .bash_profile
BASH_USER_ENV=.bashrc
# Enter automate below three modules
# No need to enter following in terminal everytime
# Please change them as your computer admin has named them
# $ module load lumerical-mode
# $ module load lumerical-interconnect
# $ module load lumerical-fdtd
MODULE_LUMERICAL_MODE="lumerical-mode"
MODULE_LUMERICAL_INTERCONNECT="lumerical-interconnect"
MODULE_LUMERICAL_FDTD="lumerical-fdtd"

# shortcuts for lumerical
# overwrite the siepic
#----------------------------------------------------------------------------------------------------------------------
#

config_bash_profile_lumerical()
{
	echo "Configuring user environment for Lumerical"
    echo "Doing nothing"
    echo "reserved For future"
    echo "Done"
}

config_bash_profile_klayout() 
{
    echo "Configuring user environment"
    echo "PATH=\$PATH:\$HOME/klayout/usr/bin" >> ~/$BASH_USER_ENV
    echo "export PATH" >> ~/$BASH_USER_ENV
    echo "LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/klayout/usr/lib64" >> ~/$BASH_USER_ENV
    echo "export LD_LIBRARY_PATH" >> ~/$BASH_USER_ENV
    source ~/$BASH_USER_ENV
    echo "Configured"
}

# Install Klayout from file
install_klayout()
{
    if [ -f "$KLAYOUT_INSTALL_FILE" ]
    then
        echo "Installing Klayout"
        unzip -oq $KLAYOUT_INSTALL_FILE
        echo "Installation complete"
        config_bash_profile_klayout
    	klayout -zz
    else
        echo "Klayout Installation file not found in home directory."
        echo "Bye bye"
    fi       
}

# Check whether klayout exists
check_klayout_exist() {
    if hash klayout 2>/dev/null; then
        echo "Klayout Found"
    else
        install_klayout
    fi
}

extract_zip_file()
{
    echo "Extracting SiEPIC_EBeam_PDK - $1"
    unzip -oq $1
    echo "Extraction Complete."
}

# Runs code for installation
install_SiEPIC() 
{
    if [ -f "$SiEPIC_FILE" ]
    then
        # offline
        echo "Starting offline Installation - $SiEPIC_FILE"
        extract_zip_file $SiEPIC_FILE
    else
        # online
        echo "Downloading SiEPIC_EBeam_PDK version: $SiEPIC_VERSION"
        wget https://github.com/lukasc-ubc/SiEPIC_EBeam_PDK/archive/v$SiEPIC_VERSION.zip
        if [ $? -ne 0 ]
            then 
                echo "Unable to Download from github." 
                return 1
        fi
        extract_zip_file v$SiEPIC_VERSION.zip
        rm v$SiEPIC_VERSION.zip
    fi
    
    echo "Installing SiEPIC_EBeam_PDK version: $SiEPIC_VERSION"
    cp -r SiEPIC_EBeam_PDK-$SiEPIC_VERSION/klayout_dot_config/* ~/.klayout/
    if [ $? -ne 0 ]
        then 
            echo "Unable to Install SiEPIC." 
            return 2
    fi
    echo "Installation complete"            
}

echo_menu_start()
{
    echo "Hi, Welcome to installation script for softwares required for RIT PIC course."
    echo "Written by Rounak Singh <rounaksingh17@gmail.com> <rn5949@rit.edu>"
    echo "Website: https://github.com/rounaksingh/install_script_RIT_PIC"
    echo "Ready to install softwares?"
    echo "Select one below by typing the number."
}

home_menu() {
	
	echo_menu_start;
	select choix in "Config user environment - Lumerical" "Install Klayout" "Install SiEPIC(require klayout)" "All" "Exit"
	do 
			
	        case $REPLY in 
	                1) config_bash_profile_lumerical ;; 
	                2) check_klayout_exist ;; 
	                3) install_SiEPIC ;;
                    4)  config_bash_profile_lumerical
                        check_klayout_exist
                        install_SiEPIC ;;
	                5) echo "Happy PICing!"
                        echo "Bye bye"
						exit ;; 
	                *) echo "~ unknown choice $REPLY" ;; 
	        esac 
	done 
}

home_menu