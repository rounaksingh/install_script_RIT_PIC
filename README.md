# install_script_RIT_PIC
A bash script for installing softwares(Klayout, SiEPIC & shortcuts for lumerical softwares) requires for mainly RIT Photonics Integrated circuits course. However, the script can be modified in many ways. Please feel free to do so.

## Platforms
* Linux
* Mac OSX (should work with prerequisites & some modification)
* Windows 10 (supposed to work with new bash integation) (not tested)

## Prerequisites
* unzip
* wget (optional, not required for offline installation)

For linux, both are already installed. 
For Mac, you might have to install the wget & unzip using https://brew.sh/
May work in Windows 10, because of new bash integration. Not tested

## How to run the script

1) Copy the script in your home directory. Also, copy required Klayout installation zip file & SiEPIC installation zip file in your home directory. It is not mandatory to install them in home. However, the script is written mainly for people who do not have superuser access.

2) Script may not be executable. Please cd to home directory and run

```bash
$ cd ~
$ chmod u+x install_RIT_PIC.sh
```

3) To run script. Do (in linux)

```bash
$ ./install_RIT_PIC.sh
```

4) The script will ask what you want to do.

5) After exiting, please restart the terminal or do
```bash
$ source ~/.bashrc
```

## Note

* Please note that lumerical softwares does not work if kgcoe-tools-01.main.ad.rit.edu is remotely accessed. Please Use Ceda lab machines.

* If no SiEPIC installation zip file found by script in its current directory. The script also provide automatic SiEPIC download form github with specific version. Please enter the version in script file. This feature may be helpful when updating SiEPIC from github.
