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

using Alcadica.Develop.Plugins.Services;
using Alcadica.Develop.Plugins.Entities.Template;

namespace com.alcadica.develop.plugins.entities { 
	public class ApplicationTemplate : Template {
		construct {
			template_description = _("Creates an elementary OS application from scratch");
			template_icon_name = "distributor-logo";
			template_name = _("elementary OS Application");

			var app_name = this.form.add_text (_("App name"), "appname");
			var app_name_token = this.add_token ("appname");
			var app_rdnn = this.form.add_text (_("RDNN name"), "rdnn_appname");
			var app_rdnn_token = this.add_token ("rdnn_appname");
			var app_folder = this.form.add_directory (_("Source code folder"), "source_folder");
			var app_folder_token = this.add_token ("source_folder");
			
			app_name.on_change.connect (value => {
				string _value = (string) value;
				app_name.is_valid = _value.chomp ().length >= 3;
				app_name_token.token_value = _value.chomp ();
			});

			app_folder.on_change.connect (value => {
				File file = (File) value;
				
				app_folder.is_valid = file != null; 

				if (file != null) {
					app_folder_token.token_value = file.get_path ();
				}
			});

			app_rdnn.on_change.connect (value => {
				string _value = (string) value;
				app_rdnn.is_valid = RDNNService.is_valid_name (_value.chomp ());
				app_rdnn_token.token_value = _value.chomp ();
			});
		}

		public override void on_request_create () {
			string root_dir = Path.build_filename (this.get_token ("source_folder").token_value, this.get_token ("rdnn_appname").token_value);
			string project_file = Path.build_filename (root_dir, "valaproject.json");
			
			this.add_files_from_directory (ElementaryTemplatesDirectory.APP);
			this.change_files_directory (ElementaryTemplatesDirectory.APP, root_dir);
			this.parse_files_content ();

			FileSystemService.mkdir (root_dir);
			
			this.write_files ();
			this.unset_files ();
			this.on_template_created (project_file);
		}
	}
}