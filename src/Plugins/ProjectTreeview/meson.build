pkg = import('pkgconfig')

my_plugin_files = files (
    'plugin.vala'
)

my_plugin = library(
    'com.github.alcadica.develop.plugin-treeview',
    my_plugin_files,
    dependencies: [
        dependency('gio-unix-2.0', version: '>=2.20'),
        dependency('libalcadicadevelopplugin')
    ],
    install: true,
    install_dir: join_paths ('share', 'com.github.alcadica.develop', 'plugins'),
    version: '0.0'
)

pkg.generate(
    description: 'Alcadica Develop Treeview Plugin',
    filebase: 'com.github.alcadica.develop.plugin-treeview',
    libraries: my_plugin,
    name: 'com.github.alcadica.develop.plugin-treeview',
    version: '0.0.1',
)