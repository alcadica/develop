# project name and programming language
project('com.github.alcadica.develop', 'vala', 'c', version: '0.1.0')

message ('project name and programming language')

# Adds project arguments
message ('Adds project arguments')

add_project_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
    ],
    language: 'c',
)

# Include the translations module
message('Include the translations module')

i18n = import('i18n')

# Set our translation domain
message ('Set our translation domain')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Adding deps
message ('Listing dependencies')

dependencies = [
    dependency('gio-unix-2.0', version: '>=2.20'),
    dependency('granite'),
    dependency('switchboard-2.0'),
]

# Adds subfolders specific build system
message ('Adds subfolders specific build system')

icon_sizes = ['32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        join_paths('data/icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )
    install_data(
        join_paths('data/icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
    )
endforeach

config_data = configuration_data()
config_data.set('EXEC_NAME', meson.project_name())

# Src build
message ('Src build')

conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())
conf_data.set_quoted('PREFIX', get_option('prefix'))

message ('Configuring desktop entry: ' + meson.project_name() + '.desktop')

desktop_in_file = configure_file(
    input: join_paths('data', meson.project_name() + '.desktop.in.in'),
    output: '@BASENAME@',
    configuration: config_data
)

desktop_file = i18n.merge_file(
    input: desktop_in_file,
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

appstream_file = i18n.merge_file(
    input: join_paths (meson.source_root(), 'data', meson.project_name() + '.appdata.xml.in'),
    output: '@BASENAME@',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

message ('Adds files to build')

code_files = files(
    'src/Application.vala',
    'src/Actions/Window/Actions.vala',
    'src/CommonRegEx.vala',
    'src/Entities/Generic/KeyValuePair.vala',
    'src/Entities/Template/TemplateFile.vala',
    'src/Entities/Template/TemplateFileType.vala',
    'src/Entities/Template/TemplateToken.vala',
    'src/Services/ActionManager.vala',
    'src/Services/FileSystem.vala',
    'src/Services/RDNN.vala',
    'src/Services/Templates/App.vala',
    'src/Services/Templates/SwitchboardWidget.vala',
    'src/Services/Templates/WingpanelWidget.vala',
    'src/Services/TemplateService.vala',
    'src/Services/UserSettings.vala',
    'src/Views/MainView.vala',
    'src/Views/Partials/Forms/FormBase.vala',
    'src/Views/Partials/Forms/FormNewApp.vala',
    'src/Views/Partials/Forms/FormNewSwitchboardWidget.vala',
    'src/Views/Partials/Forms/FormNewWingpanelWidget.vala',
    'src/Views/Partials/Forms/FormUserData.vala',
    'src/Views/Partials/Settings/SettingsBase.vala',
    'src/Views/Partials/Settings/UserDataSettings.vala',
    'src/Views/Partials/Settings/UserDataSettingsFirstRun.vala',
    'src/Views/Partials/Window/HeaderBar.vala',
    'src/Views/ProjectEditingView.vala',
    'src/Views/SettingsView.vala',
    'src/Views/WelcomeView.vala',
    'src/Widgets/ActionBar.vala',
    'src/Widgets/ComboBoxWithLabel.vala',
    'src/Widgets/Entry.vala',
    'src/Widgets/EntryWithLabel.vala',
    'src/Widgets/SettingItem.vala',
    'src/Widgets/SwitchWithLabel.vala',
)

message ('Installing schema')

install_data(
    join_paths ('data', meson.project_name() + '.gschema.xml'),
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

message ('Defines executable')

executable(
    meson.project_name(),
    code_files,
    dependencies: dependencies,
    install: true
)

meson.add_install_script('meson/postinstall.py')
