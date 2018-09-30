Develop
=======

[![Build Status](https://travis-ci.org/alcadica/develop.svg?branch=master)](https://travis-ci.org/alcadica/develop)

A simple tool to help Elementary OS developers to develop their own apps and widgets.

![](./data/screenshots/screenshot-002.png)

## Get it from the elementary OS AppCenter!

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.alcadica.develop)

Develop is available on the elementary OS AppCenter.

# Install it from source

You can of course download and install Develop from source.

## Dependencies

Ensure you have these dependencies installed

* granite
* gtk+-3.0
* switchboard-2.0

## Install, build and run

```bash
# install elementary-sdk, meson and ninja 
sudo apt install elementary-sdk meson
# clone repository
git clone https://github.com/alcadica/develop com.github.alcadica.develop
# cd to dir
cd com.github.alcadica.develop
# run meson
meson build --prefix=/usr
# use this to build and run
sudo ninja -C build/ install && com.github.alcadica.develop
```

## Running with GTK debugger/inspector

```bash
# note, enable the debugger if you have not done it yet
gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true

# run with the debugger
sudo ninja -C build/ install && GTK_DEBUG=interactive build/com.github.alcadica.develop
```

## Generating pot file

```bash
# after setting up meson build
cd build

# generates pot file
sudo ninja com.github.alcadica.develop-pot

# to regenerate and propagate changes to every po file
sudo ninja com.github.alcadica.develop-update-po
```

## Uninstall 

```bash
sudo ninja -C build uninstall
```

## Contributing

All contributions are welcome! From bug reporting, to feature request, to code contribution.

If you feel you could contribute, you are absolutely welcome!