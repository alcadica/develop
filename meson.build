# project name and programming language
project('com.github.alcadica.develop', 'vala', 'c', version: '0.0.5')

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
    dependency('libxml-2.0'),
    dependency('switchboard-2.0'),
    dependency('wingpanel-2.0'),
]

# Adds subfolders specific build system
message ('Adds subfolders specific build system')

icon_sizes = ['16', '24', '32', '48', '64', '128']

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
    'src/Actions/TemplateEditing/Actions.vala',
    'src/Actions/Window/Actions.vala',
    'src/Application.vala',
    'src/CommonRegEx.vala',
    'src/Entities/Generic/KeyValuePair.vala',
    'src/Entities/Project/Project.vala',
    'src/Entities/Project/ProjectItem.vala',
    'src/Entities/Project/ProjectItemDirectory.vala',
    'src/Entities/Project/ProjectItemSource.vala',
    'src/Entities/Project/ProjectSourceNode.vala',
    'src/Entities/Project/ProjectVersion.vala',
    'src/Entities/Template/TemplateFile.vala',
    'src/Entities/Template/TemplateFileType.vala',
    'src/Entities/Template/TemplateToken.vala',
    'src/Services/ActionManager.vala',
    'src/Services/FileSystem.vala',
    'src/Services/ProjectFileService.vala',
    'src/Services/RDNN.vala',
    'src/Services/Templates/App.vala',
    'src/Services/Templates/SwitchboardWidget.vala',
    'src/Services/Templates/WingpanelWidget.vala',
    'src/Services/TemplateService.vala',
    'src/Services/UserSettings.vala',
    'src/Views/MainView.vala',
    'src/Views/Partials/Editor/DirectoryTreeView.vala',
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
    'src/Views/TemplateCreationView.vala',
    'src/Views/WelcomeView.vala',
    'src/Widgets/ActionBar.vala',
    'src/Widgets/ComboBoxWithLabel.vala',
    'src/Widgets/Editor/Toolbar.vala',
    'src/Widgets/Entry.vala',
    'src/Widgets/EntryWithLabel.vala',
    'src/Widgets/SettingItem.vala',
    'src/Widgets/SwitchWithLabel.vala',
    'src/Window.vala',
)

message ('Installing schema')

subdir ('po')

install_data(
    join_paths ('data', meson.project_name() + '.gschema.xml'),
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

install_subdir(
    join_paths ('data', 'templates'),
    install_dir: join_paths(get_option('datadir'), meson.project_name())
)

message ('Defines executable')

executable(
    meson.project_name(),
    code_files,
    dependencies: dependencies,
    install: true
)

meson.add_install_script('meson/postinstall.py')
