project ('{{execname}}', 'vala', 'c', version: '0.0.1')

add_project_arguments (
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name ()),
    language: 'c'
)

i18n = import ('i18n')

dependencies = [
    dependency ('glib-2.0'),
    dependency ('gtk+-3.0')
]

subdir ('src')

executable (
    meson.project_name (),
    sources,
    dependencies: dependencies,
    install: true
)

subdir ('data')
subdir ('po')

meson.add_install_script ('meson/post_install.py')
