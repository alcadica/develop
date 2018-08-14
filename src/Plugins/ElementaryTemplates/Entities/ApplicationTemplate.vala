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

			var app_name = this.add_token (_("App name"), "appname");
			var app_folder = this.add_folder_selector_token (_("App folder"), "app_folder");
			var app_rdnn = this.add_token (_("RDNN name"), "rdnn_appname");
			
			app_name.validate.connect (value => {
				string _value = value.chomp ();
				
				app_name.is_valid = _value.len () >= 3;
			});

			app_folder.validate.connect (value => {
				app_folder.is_valid = value != null; 
			});

			app_rdnn.validate.connect (value => {
				string _value = value.chomp ();
				
				app_rdnn.is_valid = RDNNService.is_valid_name (_value);
			});
		}

		public override void on_request_create () {
			List<File> files = this.parse_files_with_tokens ();

			foreach (var file in files) {
				FileSystemService.write_file (file);
			}
		}
	}
}