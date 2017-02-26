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
ICON_LUMERICAL_INTERCONNECT=""
ICON_LUMERICAL_FDTD=""
ICON_MATLAB=""

#----------------------------------------------------------------------------------------------------------------------
#

# shortcuts are created on desktop
#create_shortcut
create_shortcut()
{
    SHORTCUT_NAME=$1
    SHORTCUT_CMD=$2
    SHORTCUT_ICON=$3
    echo "#!/usr/bin/env xdg-open">~/Desktop/$SHORTCUT_NAME.desktop
    echo "[Desktop Entry]">>~/Desktop/$SHORTCUT_NAME.desktop
    echo "Version=1.0">>~/Desktop/$SHORTCUT_NAME.desktop
    echo "Type=Application">>~/Desktop/$SHORTCUT_NAME.desktop
    echo "Terminal=false">>~/Desktop/$SHORTCUT_NAME.desktop
    echo "Exec=$SHORTCUT_CMD">>~/Desktop/$SHORTCUT_NAME.desktop
    echo "Name=$SHORTCUT_NAME">>~/Desktop/$SHORTCUT_NAME.desktop
    echo "Icon=$SHORTCUT_ICON">>~/Desktop/$SHORTCUT_NAME.desktop
    chmod 744 ~/Desktop/$SHORTCUT_NAME.desktop
}

create_mime_app()
{
    MIME_NAME=$1
    MIME_CMD=$2
    MIME_ICON=$3
    MIME_FILE_EXT=$4

    # Create .xml in mime
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>">~/.local/share/mime/packages/application-$MIME_FILE_EXT.xml
    echo "<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\">">>~/.local/share/mime/packages/application-$MIME_FILE_EXT.xml
    echo "<mime-type type=\"application/$MIME_FILE_EXT\">">>~/.local/share/mime/packages/application-$MIME_FILE_EXT.xml
    echo "<comment>Lumerical $MIME_NAME file</comment>">>~/.local/share/mime/packages/application-$MIME_FILE_EXT.xml
    echo "<glob pattern=\"*.$MIME_FILE_EXT\"/>">>~/.local/share/mime/packages/application-$MIME_FILE_EXT.xml
    echo "</mime-type>">>~/.local/share/mime/packages/application-$MIME_FILE_EXT.xml
    echo "</mime-info>">>~/.local/share/mime/packages/application-$MIME_FILE_EXT.xml


    # Create .desktop file in applications
    echo "#!/usr/bin/env xdg-open">~/.local/share/applications/$MIME_NAME.desktop
    echo "[Desktop Entry]">>~/.local/share/applications/$MIME_NAME.desktop
    echo "Version=1.0">>~/.local/share/applications/$MIME_NAME.desktop
    echo "Type=Application">>~/.local/share/applications/$MIME_NAME.desktop
    echo "Terminal=false">>~/.local/share/applications/$MIME_NAME.desktop
    echo "Exec=$MIME_CMD">>~/.local/share/applications/$MIME_NAME.desktop
    echo "Name=$MIME_NAME">>~/.local/share/applications/$MIME_NAME.desktop
    echo "Icon=$MIME_ICON">>~/.local/share/applications/$MIME_NAME.desktop
    echo "MimeType=application/$MIME_FILE_EXT">>~/.local/share/applications/$MIME_NAME.desktop
    

}

create_shortcuts_lumerical()
{
	echo "Creating shortcuts & file associations for Lumerical"
    # Desktop Shortcuts
    create_shortcut "interconnect" "bash -c \"source ~/.bashrc && module load $MODULE_LUMERICAL_INTERCONNECT && interconnect\"" "$ICON_LUMERICAL_INTERCONNECT"
    create_shortcut "mode-solutions" "bash -c \"source ~/.bashrc && module load $MODULE_LUMERICAL_MODE && mode-solutions\"" "$ICON_LUMERICAL_MODE"
    create_shortcut "fdtd-solutions" "bash -c \"source ~/.bashrc && module load $MODULE_LUMERICAL_FDTD && fdtd-solutions\"" "$ICON_LUMERICAL_FDTD"
    # File associations

    create_mime_app "interconnect" "bash -c \"source ~/.bashrc && module load $MODULE_LUMERICAL_INTERCONNECT && interconnect %F\"" "$ICON_LUMERICAL_INTERCONNECT" "icp"
    create_mime_app "mode-solutions" "bash -c \"source ~/.bashrc && module load $MODULE_LUMERICAL_MODE && mode-solutions %F\"" "$ICON_LUMERICAL_MODE" "lms"
    create_mime_app "fdtd-solutions" "bash -c \"source ~/.bashrc && module load $MODULE_LUMERICAL_FDTD && fdtd-solutions %F\"" "$ICON_LUMERICAL_FDTD" "fsp"

    # Update MIME
    update-mime-database ~/.local/share/mime
    update-desktop-database ~/.local/share/applications

    echo "Done"
}

create_shortcuts_matlab()
{
    echo "Creating shortcuts & file associations for Matlab"
    # Desktop Shortcuts
    create_shortcut "matlab" "bash -c \"source ~/.bashrc && module load $MODULE_MATLAB && matlab -desktop\"" "$ICON_MATLAB"

    # File associations
    create_mime_app "matlab" "bash -c \"source ~/.bashrc && module load $MODULE_MATLAB && matlab -desktop %F\"" "$ICON_MATLAB" "m"
    
    # Update MIME
    update-mime-database ~/.local/share/mime
    update-desktop-database ~/.local/share/applications

    echo "Done"
}

config_env_klayout()
{
    echo "Configuring user environment"
    echo "PATH=\$PATH:\$HOME/klayout/usr/bin" >> ~/$BASH_USER_ENV
    echo "export PATH" >> ~/$BASH_USER_ENV
    echo "LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/klayout/usr/lib64" >> ~/$BASH_USER_ENV
    echo "export LD_LIBRARY_PATH" >> ~/$BASH_USER_ENV
    source ~/$BASH_USER_ENV
    #create_shortcut "klayout" "bash -c \"PATH=\$PATH:\$HOME/klayout/usr/bin && export PATH && LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/klayout/usr/lib64 && export LD_LIBRARY_PATH && klayout\"" "~/klayout/usr/share/pixmaps/klayout.png"
    create_shortcut "klayout" "bash -c \"source ~/.bashrc && klayout\"" "~/klayout/usr/share/pixmaps/klayout.png"
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
    mkdir -p ~/.klayout
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
	select choix in "Create shorcuts for Lumerical" "Install Klayout" "Install SiEPIC(require klayout)" "Create shortcuts for Matlab" "All" "Exit"
	do 
			
	        case $REPLY in 
	                1) create_shortcuts_lumerical ;; 
	                2) check_klayout_exist ;; 
	                3) install_SiEPIC ;;
                    4) create_shortcuts_matlab;;
                    5)  create_shortcuts_lumerical
                        check_klayout_exist
                        install_SiEPIC
                        create_shortcuts_matlab;;
	                6) echo "Happy PICing!"
                        echo "Bye bye"
						exit ;;
	                *) echo "~ unknown choice $REPLY" ;; 
	        esac 
	done
}

home_menu