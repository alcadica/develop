clear

if [ ! -d "build" ]; then
  sudo meson build --prefix=/usr
fi

sudo ninja -C build/ install

if [ $? -eq 0 ]; then
  com.github.alcadica.develop
fi