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
using Alcadica.Develop.Entities.Template;
using Alcadica.Develop.Services;

namespace Alcadica.Develop.Services.Templates { 
	public class SwitchboardWidget : TemplateService { 

		protected string icon_path {
			get {
				return "data/icons/128/icon.svg";
			}
		}
		
		public SwitchboardWidget (string base_dir) {
			Object(base_dir: base_dir, template_name: "switchboard-widget");
		}
		
		protected override void on_init () {
			this.add_file (icon_path, get_content_from_shared_file (icon_path));
			this.add_file (".gitignore", get_content_from_shared_file (".gitignore"));
			this.add_file (".travis.yml", get_content_from_shared_file (".travis.yml"));
			this.add_file ("CODE_OF_CONDUCT.md", get_content_from_shared_file ("CODE_OF_CONDUCT.md"));
			this.add_file ("COPYING", get_content_from_shared_file ("COPYING"));
			this.add_file ("meson.build", get_content_from_shared_file ("meson.build"));
			this.add_file ("po/LINGUAS", get_content_from_shared_file("po/LINGUAS"));
			this.add_file ("po/meson.build", get_content_from_shared_file ("po/meson.build"));
			this.add_file ("README.md", get_content_from_shared_file ("README.md"));
			this.add_file ("src/Backend/Settings.vala", get_content_from_shared_file ("src/Backend/Settings.vala"));
			this.add_file ("src/meson.build", get_content_from_shared_file ("src/meson.build"));
			this.add_file ("src/Plug.vala", get_content_from_shared_file ("src/Plug.vala"));
			this.add_file ("src/Widgets/GeneralSection.vala", get_content_from_shared_file ("src/Widgets/GeneralSection.vala"));
			this.add_file ("src/Widgets/SettingLabel.vala", get_content_from_shared_file ("src/Widgets/SettingLabel.vala"));
		}

		protected override void on_directory_write_end (TemplateFile directory) {
			debug ("Created directory " + directory.path);
		}
		
		protected override void on_file_write_end (TemplateFile file) {
			File _file = File.new_for_path (file.path);
			string basename = _file.get_basename ();

			debug ("Created file " + file.path);

			if (basename == "icon.svg") {
				string destination = this.root_dir_name + ".svg";
				debug ("\nRenaming icon file to: " + destination);
				FileSystem.rename (_file, destination);
			}
		}
	}
}