pkg = import('pkgconfig')

plugin_name = 'com.github.alcadica.develop.plugin-treeview'
plugin_dependencies = [
    plugin_dependency
]

plugin_files = files (
    'plugin.vala',
    'handlers.vala'
)

my_plugin = shared_module(
    plugin_name,
    plugin_files,
    dependencies: plugin_dependencies,
    install: true,
    install_dir: join_paths ('share', 'com.github.alcadica.develop', 'plugins')
)

# pkg.generate(
#     description: 'Alcadica Develop Treeview Plugin',
#     filebase: 'com.github.alcadica.develop.plugin-treeview',
#     libraries: my_plugin,
#     name: 'com.github.alcadica.develop.plugin-treeview',
#     version: '0.0.1',
# )