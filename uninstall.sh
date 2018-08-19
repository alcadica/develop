clear 

if [ -d "build" ]; then
  sudo ninja -C build/ uninstall
  sudo rm -rf build/
fi