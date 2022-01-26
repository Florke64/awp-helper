<img src="./awp/awp_wallpaper_icon.png" width="150" height="150">

# About

This is set of shell tools to manage animated (video) wallpapers under the GNOME.

It automates use of CLI based [animated-wallpaper](https://github.com/Ninlives/animated-wallpaper) program, by providing step-by-step guided GUI, which can *download*, *re-configure* and *set* animated wallpaper.

It provides automated installation script, as well as uninstall script.

# Requirements

It uses [animated-wallpaper](https://github.com/Ninlives/animated-wallpaper) program, which is intended for [GNOME Desktop Enviorement](https://www.gnome.org/) - so this is primary requirement.

1. sudo (for automatic installation and uninstallation)

### shipped by install.sh:
2. [ffmpeg](https://git.ffmpeg.org/ffmpeg.git)
3. [youtube-dl](http://ytdl-org.github.io/youtube-dl/)
4. [animated-wallpaper](https://github.com/Ninlives/animated-wallpaper)


# Installation

## Automatic installation

**This will install the dependencies directly with and move the files to the correct places.**

**Fedora**, **Arch Linux**, **Manjaro** and **Ubuntu** are currently supported distros.

> ```bash
> chmod +x "install.sh"
> bash "./install.sh"
> ```

## Manual Installation

Move the folder `awp` to `/usr/local/share/`
> ```bash
> sudo cp -r "awp" "/usr/local/share/awp"
> ```

Move the `.desktop` file to `/usr/share/applications/`
> ```bash
> sudo cp -r *."desktop" "/usr/share/applications/"
> ```

Add 'x' attribute to the files (execute permission)  
> ```bash
> sudo chmod +x "/usr/local/share/awp/"*.sh
> ```
Reload GNOME - if using X11: press `F2`, type `r` and press `Enter ⏎ ` (may not be always needed).

# Notice:
> The **X11 version** of GNOME is **recommended** for this, as this will only work on a Wayland workspace.

## Icon from:
> <https://icon-icons.com/icon/wallpaper/104166> by **Jeremiah**
>
> **License:** <https://creativecommons.org/licenses/by/4.0/> (CC BY 4.0)

## YouTube Preview

[![Youtube](https://img.youtube.com/vi/4gufe3x7oZA/0.jpg)](https://www.youtube.com/watch?v=4gufe3x7oZA)

# License

This repository is licensed under the free GPL-3.0 license.

When we speak of free software, we are referring to freedom, not price. [...] you have the freedom to distribute copies of free software (and charge for them if you wish).
> Please read a [LICENSE](/LICENSE) file for more details.