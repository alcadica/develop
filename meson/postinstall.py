#!/usr/bin/env python3

import distutils
from distutils import dir_util
import os
import subprocess

print('Starts copying template files')

install_prefix = os.environ['MESON_INSTALL_PREFIX']

schemadir = os.path.join(install_prefix, 'share', 'glib-2.0', 'schemas')
iconsdir = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'icons', 'hicolor')

print('Files copied successfully')

if not os.environ.get('DESTDIR'):
    print('Compiling gsettings schemas...')
    subprocess.call(['glib-compile-schemas', schemadir])

    print('Updating icon cache...')

    if not os.path.exists(iconsdir):
        os.makedirs(iconsdir)
    subprocess.call(['gtk-update-icon-cache', '-qtf', iconsdir])