#!/usr/bin/env python3

import distutils
from distutils import dir_util
import os
import subprocess

print('Starts copying template files')

home_share_dir = os.path.join(os.path.expanduser ('~'))
project_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)))
templates_dir_src = os.path.join(project_dir, 'data', 'templates')
templates_dir_dest = os.path.join(home_share_dir, '.local', 'share', 'com.github.alcadica.develop', 'templates')

install_prefix = os.environ['MESON_INSTALL_PREFIX']
schemadir = os.path.join(install_prefix, 'share', 'glib-2.0', 'schemas')

print(templates_dir_src)
print(templates_dir_dest)

print('Copying from \n\t' + templates_dir_src + ' \nto \n\t' + templates_dir_dest)

distutils.dir_util.copy_tree(templates_dir_src, templates_dir_dest)

for root, dirs, files in os.walk(templates_dir_dest):
    for d in dirs:
        os.chmod(os.path.join(root, d), 0o777)
    for f in files:
        os.chmod(os.path.join(root, f), 0o777)

print('Files copied successfully')

if not os.environ.get('DESTDIR'):
    print('Compiling gsettings schemas...')
    subprocess.call(['glib-compile-schemas', schemadir])