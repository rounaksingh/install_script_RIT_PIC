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
MODULE_MATLAB="matlab"

# icon picture file path
ICON_LUMERICAL_MODE=""
ICON_LUMERICAL_INTERCONNECT="$HOME/.local/share/icons/hicolor/48x48/apps/application-icp.png"
ICON_LUMERICAL_FDTD=""
ICON_MATLAB=""

#----------------------------------------------------------------------------------------------------------------------
#
if [ -f /etc/redhat-release ] 
    then
    RED_HAT_VERSION=$(cat /etc/redhat-release | grep -oP '(?:(\d+)\.)' |grep -oP '\d')
else
    RED_HAT_VERSION="0"
fi

# shortcuts are created on desktop
#create_shortcut
create_shortcut()
{
    SHORTCUT_NAME=$1
    SHORTCUT_CMD=$2
    SHORTCUT_ICON=$3
    DIR_PATH="$HOME/Desktop/"
    mkdir -p $DIR_PATH

    echo "#!/usr/bin/env xdg-open">$DIR_PATH/$SHORTCUT_NAME.desktop
    echo "[Desktop Entry]">>$DIR_PATH/$SHORTCUT_NAME.desktop
    echo "Version=1.0">>$DIR_PATH/$SHORTCUT_NAME.desktop
    echo "Type=Application">>$DIR_PATH/$SHORTCUT_NAME.desktop
    echo "Terminal=false">>$DIR_PATH/$SHORTCUT_NAME.desktop
    echo "Exec=$SHORTCUT_CMD">>$DIR_PATH/$SHORTCUT_NAME.desktop
    echo "Name=$SHORTCUT_NAME">>$DIR_PATH/$SHORTCUT_NAME.desktop
    echo "Icon=$SHORTCUT_ICON">>$DIR_PATH/$SHORTCUT_NAME.desktop
    
    chmod 744 $DIR_PATH/$SHORTCUT_NAME.desktop
}

create_mime_app()
{
    MIME_NAME=$1
    MIME_CMD=$2
    MIME_ICON=$3
    MIME_FILE_EXT=$4
    MIME_DIR_PATH="$HOME/.local/share/mime/packages"
    MIME_APP_DIR_PATH="$HOME/.local/share/applications"

    # Create .xml in mime
    mkdir -p $MIME_DIR_PATH
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>">$MIME_DIR_PATH/application-$MIME_FILE_EXT.xml
    echo "<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\">">>$MIME_DIR_PATH/application-$MIME_FILE_EXT.xml
    echo "<mime-type type=\"application/$MIME_FILE_EXT\">">>$MIME_DIR_PATH/application-$MIME_FILE_EXT.xml
    echo "<comment>Lumerical $MIME_NAME file</comment>">>$MIME_DIR_PATH/application-$MIME_FILE_EXT.xml
    echo "<glob pattern=\"*.$MIME_FILE_EXT\"/>">>$MIME_DIR_PATH/application-$MIME_FILE_EXT.xml
    echo "</mime-type>">>$MIME_DIR_PATH/application-$MIME_FILE_EXT.xml
    echo "</mime-info>">>$MIME_DIR_PATH/application-$MIME_FILE_EXT.xml


    # Create .desktop file in applications
    mkdir -p $MIME_APP_DIR_PATH
    echo "#!/usr/bin/env xdg-open">$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "[Desktop Entry]">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "Version=1.0">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "Type=Application">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "Terminal=false">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "Exec=$MIME_CMD">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "Name=$MIME_NAME">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "Icon=$MIME_ICON">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    echo "MimeType=application/$MIME_FILE_EXT">>$MIME_APP_DIR_PATH/$MIME_NAME.desktop
    

}

create_shortcuts_lumerical()
{
	echo "Creating shortcuts & file associations for Lumerical"
    # Desktop Shortcuts
    create_shortcut "interconnect" "bash -c \"source $HOME/.bashrc && module load $MODULE_LUMERICAL_INTERCONNECT $MODULE_MATLAB && interconnect\"" "$ICON_LUMERICAL_INTERCONNECT"
    create_shortcut "mode-solutions" "bash -c \"source $HOME/.bashrc && module load $MODULE_LUMERICAL_MODE $MODULE_MATLAB && mode-solutions\"" "$ICON_LUMERICAL_MODE"
    create_shortcut "fdtd-solutions" "bash -c \"source $HOME/.bashrc && module load $MODULE_LUMERICAL_FDTD $MODULE_MATLAB && fdtd-solutions\"" "$ICON_LUMERICAL_FDTD"
    # File associations
    create_mime_app "interconnect" "bash -c \"source $HOME/.bashrc && module load $MODULE_LUMERICAL_INTERCONNECT $MODULE_MATLAB && interconnect %F\"" "$ICON_LUMERICAL_INTERCONNECT" "icp"
    create_mime_app "mode-solutions" "bash -c \"source $HOME/.bashrc && module load $MODULE_LUMERICAL_MODE $MODULE_MATLAB && mode-solutions %F\"" "$ICON_LUMERICAL_MODE" "lms"
    create_mime_app "fdtd-solutions" "bash -c \"source $HOME/.bashrc && module load $MODULE_LUMERICAL_FDTD $MODULE_MATLAB && fdtd-solutions %F\"" "$ICON_LUMERICAL_FDTD" "fsp"

    # Update MIME
    update-mime-database $HOME/.local/share/mime
    update-desktop-database $HOME/.local/share/applications

    echo "Done"
}

create_shortcuts_matlab()
{
    echo "Creating shortcuts & file associations for Matlab"
    # Desktop Shortcuts
    create_shortcut "matlab" "bash -c \"source $HOME/.bashrc && module load $MODULE_MATLAB && matlab -desktop\"" "$ICON_MATLAB"

    # File associations
    create_mime_app "matlab" "bash -c \"source $HOME/.bashrc && module load $MODULE_MATLAB && matlab -desktop %F\"" "$ICON_MATLAB" "m"
    
    # Update MIME
    update-mime-database $HOME/.local/share/mime
    update-desktop-database $HOME/.local/share/applications

    echo "Done"
}

config_env_klayout()
{
    echo "Configuring user environment"
    echo "PATH=\$PATH:\$HOME/klayout/usr/bin" >> $HOME/$BASH_USER_ENV
    echo "export PATH" >> $HOME/$BASH_USER_ENV
    echo "LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/klayout/usr/lib64" >> $HOME/$BASH_USER_ENV
    echo "export LD_LIBRARY_PATH" >> $HOME/$BASH_USER_ENV
    source $HOME/$BASH_USER_ENV
    #create_shortcut "klayout" "bash -c \"PATH=\$PATH:\$HOME/klayout/usr/bin && export PATH && LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/klayout/usr/lib64 && export LD_LIBRARY_PATH && klayout\"" "$HOME/klayout/usr/share/pixmaps/klayout.png"
    create_shortcut "klayout" "bash -c \"source $HOME/.bashrc && klayout\"" "$HOME/klayout/usr/share/pixmaps/klayout.png"
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
        config_env_klayout
    	#klayout -zz
    else
        echo "Klayout Installation file not found in home directory."
        echo "Bye bye"
        return 1
    fi

    return 0
}

# Check whether klayout exists
check_klayout_exist() {
    if hash klayout 2>/dev/null; then
        echo "Klayout Found"
    else
        install_klayout
        if [ $? -ne 0 ]
            then 
                echo "Unable to Install Klayout." 
                return 1
        fi
    fi

    return 0
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
	check_klayout_exist
	if [ $? -ne 0 ]
            then 
                echo "Cannot install SiEPIC. No Klayout found" 
                return 3
    fi

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
    mkdir -p $HOME/.klayout
    cp -r SiEPIC_EBeam_PDK-$SiEPIC_VERSION/klayout_dot_config/* $HOME/.klayout/
    if [ $? -ne 0 ]
        then 
            echo "Unable to Install SiEPIC." 
            return 2
    fi
    echo "Installation complete"            
}

config_nautilus_browser_mode()
{
    if [ $RED_HAT_VERSION -eq "0" ]
        then
        return
    fi

    echo "Configuring Nautilus - browser mode"

    if [ $RED_HAT_VERSION -lt "7" ]
        then
        # New redhat versions have gconftools Refer: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Desktop_Migration_and_Administration_Guide/gsettings-dconf.html
        gconftool-2 -t bool -s /apps/nautilus/preferences/always_use_browser true
    else
        # New redhat versions have dconftools
        dconftool-2 -t bool -s /apps/nautilus/preferences/always_use_browser true
    fi
    echo "Done"
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
	select choix in "Create shorcuts for Lumerical" "Install Klayout" "Install SiEPIC(require klayout)" "Create shortcuts for Matlab" "Configure Nautilus" "All" "Exit"
	do 
			
	        case $REPLY in 
	                1) create_shortcuts_lumerical ;; 
	                2) check_klayout_exist ;; 
	                3) install_SiEPIC ;;
                    4) create_shortcuts_matlab;;
                    5) config_nautilus_browser_mode;;
                    6) create_shortcuts_lumerical
                        check_klayout_exist
                        install_SiEPIC
                        create_shortcuts_matlab
                        config_nautilus_browser_mode;;
	                7) echo "Happy PICing!"
                        echo "Bye bye"
						exit ;;
	                *) echo "~ unknown choice $REPLY" ;; 
	        esac 
	done
}

home_menu