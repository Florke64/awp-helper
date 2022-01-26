#!/bin/bash

if [ $(whoami) == 'root' ]; then
    echo "Please run as regular user!"
    exit 1
fi

ORIGIN_USER=$(whoami)

# Returns True(0) if argument is True(0), exits script otherwise
function test_fail() {
    local value=$1

    case $value in 
    0)
        test_fail=0 # true
        ;;
    1)
        zenity --info --width=500\
            --text="Unfortunately, it is not possible for me to work like this."
        test_fail=1 # false, but it will not really return
        exit 0
        ;;
    -1)
        echo "Exiting..."
        test_fail=1 # false
        exit 1
        ;;
    esac
}

echo "Asking for sudo password"
PASS=`zenity --password --title "Install Animated Wallpaper"`

# Checking if user has cancelled the password prompt
test_fail $?

# Checking if provided password isn't empty
if [ -z "$PASS" ]; then
    zenity --question --width=500\
        --text="Provided empty sudo password. Continue?"
    
    test_fail $?
fi

# Checking if provided password is correct
echo "$PASS" | sudo -S -k -v
if (( $((`test_fail $?`)) == 0 )); then
    echo "Verified sudo privileges."
fi

# Detect OS
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

# Install Dependencies
if [ "$OS" == "Fedora Linux" ]; then
    # Fedora
    zenity --question --width 500\
        --text="Fedora Detected. It needs to intigrate the rpmfusion repository for ffmpeg. Do you agree with this?"

    if (( $((`test_fail $?`)) == 0 )); then
        echo Installing Fedora Dependencies
        echo Add rpmfusion repository for ffmpeg
        echo "$PASS" | sudo -S dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
        echo Installing dev tools and dependencies
        echo "$PASS" | sudo -S dnf install -y cmake gcc-c++ vala pkgconfig gtk3-devel clutter-devel clutter-gtk-devel clutter-gst3-devel youtube-dl ffmpeg && STATUS="OK"
    fi
            
elif [[ "$OS" == "Manjaro Linux" ]]; then
    # Manjaro
    zenity --question --width 500\
    --text="Manjaro Detected. Is this correct?"
    
    if (( $((`test_fail $?`)) == 0 )); then
        echo Renewing Package Database
        echo "$PASS" | sudo -S pacman -Sy
        echo Installing Manjaro Dependencies  
        echo "$PASS" | sudo -S pacman -S base-devel ffmpeg youtube-dl cmake vala pkgconfig gtk3 clutter clutter-gtk clutter-gst gst-libav --noconfirm && STATUS="OK"
    fi

elif [[ "$OS" == "Arch Linux" ]]; then
    # Arch
    zenity --question --width 500\
    --text="Arch Linux Detected. Is this correct?"

    
    if (( $((`test_fail $?`)) == 0 )); then
        echo Renewing Package Database
        echo "$PASS" | sudo -S pacman -Sy
        echo Installing Arch Linux Dependencies       
        echo "$PASS" | sudo -S pacman -S git base-devel ffmpeg youtube-dl cmake vala pkgconfig gtk3 clutter clutter-gtk clutter-gst gst-libav --noconfirm && STATUS="OK"
    fi

elif [[ "$OS" == "Ubuntu" ]]; then
    # Ubuntu
    zenity --question --width 500\
    --text="Ubuntu Detected. Is this correct?"
    
    
    if (( $((`test_fail $?`)) == 0 )); then
        echo Renewing Package Database
        echo "$PASS" | sudo -S apt-get update
        echo Installing Ubuntu Dependencies       
        echo "$PASS" | sudo -S apt install git ffmpeg youtube-dl valac cmake pkg-config libgtk-3-dev libclutter-gtk-1.0-dev libclutter-gst-3.0-dev build-essential --yes && STATUS="OK" 
    fi
        
else
    echo "This OS is not Supported!"
fi

if [ "$STATUS" == "OK" ]; then
    # Clone and Install animated-wallpaper
    echo 'Cloning animated-wallpaper from github. (https://github.com/Ninlives/animated-wallpaper)'

    git clone https://github.com/Ninlives/animated-wallpaper
    cd animated-wallpaper
    cmake . && make && echo "$PASS" | sudo -S make install
    cd ..
    rm -rf animated-wallpaper

    # Install animated_wallpaper_helper
    echo "$PASS" | sudo -S cp -r awp /usr/local/share/
    echo "$PASS" | sudo -S cp awp.desktop /usr/share/applications/
    echo "$PASS" | sudo -S chmod +x /usr/local/share/awp/awp.sh
    echo "$PASS" | sudo -S chmod +x /usr/local/share/awp/awp-autostart.sh

    echo "Animated Wallpapers was installed successfully."

    zenity --question --width 500\
        --text="Animated Wallpapers was installed successfully. Do you want to start the script now?"

    
    if (( $((`test_fail $?`)) == 0 )); then
        echo Start Animated Wallpaper
        sudo -u $ORIGIN_USER sh "/usr/local/share/awp/awp.sh"
    fi

else
    err_os=(
        "Sorry but the Installer does not work on your system!"
        "Fedora, Arch Linux, Manjaro and Ubuntu are currently supported."
    )

    echo -e "${err_os[0]}\n${err_os[1]}"
    zenity --error --width=360 --text="${err_os[0]} ${err_os[1]}"
fi
