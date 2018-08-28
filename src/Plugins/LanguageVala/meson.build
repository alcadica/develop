pkg = import('pkgconfig')

plugin_name = 'com.github.alcadica.develop.plugin-language-vala'
plugin_dependencies = [
    plugin_dependency,
    declare_dependency(
        dependencies: [
            dependency('json-glib-1.0')
        ]
    )
]

plugin_files = files (
    'plugin.vala',
    'entities/Project/ValaProjectJSON.vala',
    'entities/Project/ValaProjectParser.vala'
)

my_plugin = shared_module(
    plugin_name,
    plugin_files,
    dependencies: plugin_dependencies,
    install: true,
    install_dir: join_paths ('local', 'share', 'com.github.alcadica.develop', 'plugins')
)