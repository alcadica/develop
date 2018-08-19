pkg = import('pkgconfig')

plugin_name = 'com.github.alcadica.develop.plugin-elementary-os-templates'
plugin_dependencies = [
    plugin_dependency
]

plugin_files = files (
    'plugin.vala',
    'Entities/ApplicationTemplate.vala',
    'Entities/SwitchboardWidgetTemplate.vala',
    'Entities/WingpanelIndicatorTemplate.vala'
)

install_subdir(
    join_paths ('data', 'templates'),
    install_dir: join_paths(get_option('datadir'), 'com.github.alcadica.develop.plugin-elementary-os-templates')
)

my_plugin = shared_module(
    plugin_name,
    plugin_files,
    dependencies: plugin_dependencies,
    install: true,
    install_dir: join_paths ('local', 'share', 'com.github.alcadica.develop', 'plugins')
)