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
pkg = import('pkgconfig')

# Set our translation domain
message ('Set our translation domain')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Adding deps
message ('Listing dependencies')

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
    'src/Develop/Actions/TemplateEditing/Actions.vala',
    'src/Develop/Actions/Window/Actions.vala',
    'src/Develop/Application.vala',
    'src/Develop/CommonRegEx.vala',
    'src/Develop/Entities/Generic/KeyValuePair.vala',
    'src/Develop/Entities/Template/TemplateFile.vala',
    'src/Develop/Entities/Template/TemplateFileType.vala',
    'src/Develop/Entities/Template/TemplateToken.vala',
    'src/Develop/Services/ActionManager.vala',
    'src/Develop/Services/FileSystem.vala',
    'src/Develop/Services/RDNN.vala',
    'src/Develop/Services/Templates/App.vala',
    'src/Develop/Services/Templates/SwitchboardWidget.vala',
    'src/Develop/Services/Templates/WingpanelWidget.vala',
    'src/Develop/Services/TemplateService.vala',
    'src/Develop/Services/UserSettings.vala',
    'src/Develop/Views/MainView.vala',
    'src/Develop/Views/Partials/Editor/DirectoryTreeView.vala',
    'src/Develop/Views/Partials/Forms/FormBase.vala',
    'src/Develop/Views/Partials/Forms/FormNewApp.vala',
    'src/Develop/Views/Partials/Forms/FormNewSwitchboardWidget.vala',
    'src/Develop/Views/Partials/Forms/FormNewWingpanelWidget.vala',
    'src/Develop/Views/Partials/Forms/FormUserData.vala',
    'src/Develop/Views/Partials/Settings/SettingsBase.vala',
    'src/Develop/Views/Partials/Settings/UserDataSettings.vala',
    'src/Develop/Views/Partials/Settings/UserDataSettingsFirstRun.vala',
    'src/Develop/Views/Partials/Window/HeaderBar.vala',
    'src/Develop/Views/ProjectEditingView.vala',
    'src/Develop/Views/SettingsView.vala',
    'src/Develop/Views/TemplateCreationView.vala',
    'src/Develop/Views/WelcomeView.vala',
    'src/Develop/Widgets/ActionBar.vala',
    'src/Develop/Widgets/ComboBoxWithLabel.vala',
    'src/Develop/Widgets/Editor/Toolbar.vala',
    'src/Develop/Widgets/Entry.vala',
    'src/Develop/Widgets/EntryWithLabel.vala',
    'src/Develop/Widgets/SettingItem.vala',
    'src/Develop/Widgets/SwitchWithLabel.vala',
    'src/Develop/Window.vala',
)

lib_vala_project_files = files(
    'src/LibAlcadicaValaProject/Entities/Project.vala',
    'src/LibAlcadicaValaProject/Entities/ProjectItem.vala',
    'src/LibAlcadicaValaProject/Entities/ProjectItemDirectory.vala',
    'src/LibAlcadicaValaProject/Entities/ProjectItemSource.vala',
    'src/LibAlcadicaValaProject/Entities/ProjectVersion.vala',
    'src/LibAlcadicaValaProject/Services/ProjectSourceNode.vala',
    'src/LibAlcadicaValaProject/Services/XMLProjectFileParser.vala',
    'src/LibAlcadicaValaProject/Services/XMLProjectFileWriter.vala',
    'src/LibAlcadicaValaProject/Main.vala',
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

lib_vala_project = library(
    'libalcadicavalaproject',
    lib_vala_project_files,
    dependencies: [
        dependency('gio-unix-2.0', version: '>=2.20'),
        dependency('libxml-2.0')        
    ],
    install: true,
    install_dir: [true, true, true],
    version: '0.0'
)

executable(
    meson.project_name(),
    code_files,
    dependencies: [
        dependency('gio-unix-2.0', version: '>=2.20'),
        dependency('granite'),
        dependency('libxml-2.0'),
        dependency('switchboard-2.0'),
        dependency('wingpanel-2.0')
    ],
    install: true,
    link_with: [
        lib_vala_project
    ]
)

pkg.generate(
    version: '0.1',
    libraries: lib_vala_project,
    description: 'Alcadica Develop Vala project',
    name: 'libalcadicavalaproject',
    filebase: 'libalcadicavalaproject'
)

meson.add_install_script('meson/postinstall.py')
