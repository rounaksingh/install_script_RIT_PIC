#! /usr/bin/env bash
#
# Install SiEPCI on a pre-install Klayout
# For Linux
# Written by Rounak Singh Narde <rn5949@rit.edu>
#
# Required: Klayout plus unzip, wget is required
# 
# - Installation checks for klayout. It runs only if klayout is installed.
#
# -Two way installation - offline and online
# -- offline - installation requires already downloaded zip file. It should be in current directory. 
# The filename should be provided below. The hierarchy should be the same as downloaded from github. 
# -- online - script download zip file from github. A released version number should be provided below.
#
#----------------------------------------------------------------------------------------------------------------------

#
# -offline- SiEPIC_file name - if you have a previously downloaded file then write a filename.
# Note the hierarchy of directories should be the same as downloaded from github
SiEPIC_file="SiEPIC_EBeam_PDK-0.1.35_RITLinux.zip"

# -online- Enter SiEPIC version as in github releases
SiEPIC_VERSION="0.1.35"

#
#----------------------------------------------------------------------------------------------------------------------
#
config_bash_profile() 
{
    echo "Configuring .bash_profile"
    echo "PATH=\$PATH:\$HOME/bin:\$HOME/klayout/usr/bin" >> ~/.bash_profile
    echo "export PATH" >> ~/.bash_profile
    echo "LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/klayout/usr/lib64" >> ~/.bash_profile
    echo "export LD_LIBRARY_PATH" >> ~/.bash_profile
    echo "Configured"
}

# Check whether klayout exists
check_klayout_exist() 
{
    if hash klayout 2>/dev/null; then
        echo "Klayout Found"
    else
        echo "Klayout Not Found. Please install Klayout"
        echo "Bye bye"
        exit 2
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

    if [ -f "$SiEPIC_file" ]
    then
        # offline
        echo "Starting offline Installation"
        extract_zip_file $SiEPIC_file
    else
        # online
        echo "Downloading SiEPIC_EBeam_PDK version: $SiEPIC_VERSION"
        wget https://github.com/lukasc-ubc/SiEPIC_EBeam_PDK/archive/v$SiEPIC_VERSION.zip
        if [ $? -ne 0 ]
            then 
                echo "Unable to Download from github." 
                exit 1
        fi
        extract_zip_file v$SiEPIC_VERSION.zip
        rm v$SiEPIC_VERSION.zip
    fi
     
    echo "Installing SiEPIC_EBeam_PDK version: $SiEPIC_VERSION"
    cp -r SiEPIC_EBeam_PDK-$SiEPIC_VERSION/klayout_dot_config/* ~/.klayout/
    echo "Installation complete"
}

check_klayout_exist
install_SiEPIC
config_bash_profile
exit 0
