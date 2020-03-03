/*
* Copyright (c) 2011-2018 alcadica (https://www.alcadica.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: alcadica <github@alcadica.com>
*/
using Alcadica.Entities.Template;
using Alcadica.Services;

namespace Alcadica.Services.Templates {
    public class WingpanelWidget : TemplateService {

        public WingpanelWidget (string base_dir) {
            Object (base_dir: base_dir, template_name: "wingpanel-widget");
        }

        protected override void on_init () {
            this.add_file ("po/LINGUAS", get_content_from_shared_file ("po/LINGUAS"));
            this.add_file ("po/meson.build", get_content_from_shared_file ("po/meson.build"));
            this.add_file ("src/Indicator.vala", get_content_from_shared_file ("src/Indicator.vala"));
            this.add_file (".editorconfig", get_content_from_shared_file (".editorconfig"));
            this.add_file (".travis.yml", get_content_from_shared_file (".travis.yml"));
            this.add_file ("COPYING", get_content_from_shared_file ("COPYING"));
            this.add_file ("meson.build", get_content_from_shared_file ("meson.build"));
            this.add_file ("README.md", get_content_from_shared_file ("README.md"));
        }

        protected override void on_directory_write_end (TemplateFile directory) {
            debug ("Created directory " + directory.path);
        }

        protected override void on_file_write_end (TemplateFile file) {
            debug ("Created file " + file.path);
        }
    }
}
