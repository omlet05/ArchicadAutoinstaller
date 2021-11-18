#!/bin/bash
#Archicad unattented installer script.

installerurl=https://gsdownloads-cdn.azureedge.net/cdn/AC/24/FRA/ARCHICAD-24-FRA-3008-1.1.dmg
installerversiondmg=ARCHICAD-24-FRA-3008-1.1.dmg
installerapppath=/Volumes/ARCHICAD\ 24/ARCHICAD\ Installer.app
installervolumename=/Volumes/ARCHICAD\ 24

updateurl=https://gsdownloads-cdn.azureedge.net/cdn/ftp/techsupport/downloads/ac24/ARCHICAD-24-FRA-Update-6004-1.0.dmg
updateversiondmg=ARCHICAD-24-FRA-Update-6004-1.0.dmg
updateapppath=/Volumes/ARCHICAD\ 24\ Update\ \(6004\)/ARCHICAD-24-FRA-Update-6004-1.0.app
updatevolumename=/Volumes/ARCHICAD\ 24\ Update\ \(6004\)

goodiesurl=https://gsdownloads-cdn.azureedge.net/cdn/ftp/techsupport/downloads/goodies24/FRA/Goodies_Suite-24-FRA-3008-1.0.dmg
goodiesversiondmg=Goodies_Suite-24-FRA-3008-1.0.dmg
goodiesapppath=/Volumes/ARCHICAD\ 24\ Goodies\ Suite/ARCHICAD\ Goodies\ Suite\ Installer.app
goodiesvolumename=/Volumes/ARCHICAD\ 24\ Goodies\ Suite


if (( $EUID != 0 )); then
    echo "Please run as root (sudo scriptname)"
    exit
fi

cd /tmp/

echo "Install of Archicad"
read -p "Install $installerversiondmg? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo "downloading $installerversiondmg..."
curl $installerurl -o /tmp/$installerversiondmg
echo "installing $installerversiondmg..."
/usr/bin/hdiutil attach /tmp/$installerversiondmg
"$installerapppath"/Contents/MacOS/installbuilder.sh --mode unattended --enableautomaticupdate 0 --rebootAnswer 0 --dockshortcut 1 --unattendedmodeui minimalWithDialogs
/usr/bin/hdiutil detach "$installervolumename"
/bin/rm /tmp/$installerversiondmg
echo "Install of $installerversiondmg done!"

fi

echo "Install of Archicad Update"
read -p "Install $updateversiondmg? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo "downloading $updateversiondmg..."
curl $updateurl -o /tmp/$updateversiondmg
echo "installing $updateversiondmg..."
/usr/bin/hdiutil attach /tmp/$updateversiondmg
"$updateapppath"/Contents/MacOS/installbuilder.sh --mode unattended --unattendedmodeui minimalWithDialogs
/usr/bin/hdiutil detach "$updatevolumename"
/bin/rm /tmp/$updateversiondmg
echo "Install of $updateversiondmg done!"

fi

echo "Install of Archicad Goodies pack"
read -p "Install $goodiesversiondmg? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo "downloading $goodiesversiondmg..."
curl $goodiesurl -o /tmp/$goodiesversiondmg
echo "installing $goodiesversiondmg..."
/usr/bin/hdiutil attach /tmp/$goodiesversiondmg
"$goodiesapppath"/Contents/MacOS/installbuilder.sh --mode unattended --unattendedmodeui minimalWithDialogs
/usr/bin/hdiutil detach "$goodiesvolumename"
/bin/rm /tmp/$goodiesversiondmg
echo "Install of $goodiesversiondmg done!"

fi


read -p "Relaunch Codemeter Service? (required if Archicad is running) (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo "Stopping CodeMeter service..."
/bin/launchctl unload -w /Library/LaunchDaemons/com.wibu.CodeMeter.Server.plist
echo "Starting CodeMeter service..."
/bin/launchctl load -w /Library/LaunchDaemons/com.wibu.CodeMeter.Server.plist

fi

echo "Script done!"

exit 0
