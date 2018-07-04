pkg = import('pkgconfig')

plugin_name = 'com.github.alcadica.develop.plugin-elementary-os-templates'
plugin_dependencies = [
    plugin_dependency
]

plugin_files = files (
    'plugin.vala'
)

my_plugin = shared_module(
    plugin_name,
    plugin_files,
    dependencies: plugin_dependencies,
    install: true,
    install_dir: join_paths ('local', 'share', 'com.github.alcadica.develop', 'plugins')
)