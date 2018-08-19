clear

if [ ! -d "build" ]; then
  sudo meson build --prefix=/usr
fi

sudo ninja -C build/ install

com.github.alcadica.develop