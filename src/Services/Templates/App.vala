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
	public class App : TemplateService { 

		public unowned string appdata_xml = "appdata.xml.in";
		public unowned string desktop_entry = "desktop.in";
		
		public App (string base_dir) {
			Object(base_dir: base_dir, template_name: "app");
		}
		
		protected override void on_init () {
		    this.add_file ("data/icons/16/name.svg", get_content_from_shared_file ("data/icons/16/name.svg"));
			this.add_file ("data/icons/24/name.svg", get_content_from_shared_file ("data/icons/24/name.svg"));
			this.add_file ("data/icons/32/name.svg", get_content_from_shared_file ("data/icons/32/name.svg"));
			this.add_file ("data/icons/48/name.svg", get_content_from_shared_file ("data/icons/48/name.svg"));
			this.add_file ("data/icons/64/name.svg", get_content_from_shared_file ("data/icons/64/name.svg"));
			this.add_file ("data/icons/128/name.svg", get_content_from_shared_file ("data/icons/128/name.svg"));
			this.add_file ("data/icons/name.svg", get_content_from_shared_file ("data/icons/name.svg"));
            this.add_file ("data/" + this.appdata_xml, get_content_from_shared_file ("data/appdata.xml"));
			this.add_file ("data/" + this.desktop_entry, get_content_from_shared_file ("data/desktop"));
            this.add_file ("data/meson.build", get_content_from_shared_file ("data/meson.build"));
            
            this.add_file ("meson/post_install.py", get_content_from_shared_file ("meson/post_install.py"));
        
            this.add_file ("po/extra/LINGUAS", get_content_from_shared_file ("po/extra/LINGUAS"));
            this.add_file ("po/extra/meson.build", get_content_from_shared_file ("po/extra/meson.build"));
            this.add_file ("po/extra/POTFILES", get_content_from_shared_file ("po/extra/POTFILES"));
            this.add_file ("po/LINGUAS", get_content_from_shared_file ("po/LINGUAS"));
            this.add_file ("po/meson.build", get_content_from_shared_file ("po/meson.build"));
            this.add_file ("po/POTFILES", get_content_from_shared_file ("po/POTFILES"));
                        
            this.add_file ("src/Application.vala", get_content_from_shared_file ("src/Application.vala"));
            this.add_file ("src/meson.build", get_content_from_shared_file ("src/meson.build"));
            
            this.add_file (".editorconfig", get_content_from_shared_file (".editorconfig"));
			this.add_file (".gitignore", get_content_from_shared_file (".gitignore"));
			this.add_file (".travis.yml", get_content_from_shared_file (".travis.yml"));
            this.add_file ("meson.build", get_content_from_shared_file ("meson.build"));
            this.add_file ("README.md", get_content_from_shared_file ("README.md"));
        }

		protected override void on_directory_write_end (TemplateFile directory) { }

		protected override void on_file_write_end (TemplateFile file) {
			File _file = File.new_for_path (file.path);
			string basename = _file.get_basename ();
            
			if (basename == this.appdata_xml) {
				string destination = this.root_dir_name + ".appdata.xml.in";
				debug ("\nRenaming appdata file to: " + destination);
				FileSystem.rename (_file, destination);
			} else if (basename == this.desktop_entry) {
				string destination = this.root_dir_name + ".desktop.in";
				debug ("\nRenaming desktop file to: " + destination);
				FileSystem.rename (_file, destination);
			} else if (basename == "name.svg") {
				string destination = this.root_dir_name + ".svg";
				debug ("\nRenaming icon file to: " + destination);
				FileSystem.rename (_file, destination);
            }
		}
	}
}
