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

using Alcadica.Develop.Plugins.Entities;
using Alcadica.Develop.Plugins.Services;

namespace com.alcadica.develop.plugins.entities { 
	public class SwitchboardWidgetTemplate : Template.Template {
		construct {
			template_description = _("Creates a Switchboard (the settings App) widget");
			template_icon_name = "preferences-desktop";
			template_name = _("Switchboard widget");

			List<Common.KeyValuePair<int, string>> widget_types = new List<Common.KeyValuePair<int, string>> ();

			widget_types.append (new Common.KeyValuePair<int, string> (1, _("Personal")));
			widget_types.append (new Common.KeyValuePair<int, string> (2, _("Hardware")));
			widget_types.append (new Common.KeyValuePair<int, string> (3, _("Network & Wireless")));
			widget_types.append (new Common.KeyValuePair<int, string> (4, _("Administration")));

			var widget_type = this.add_token_list (_("Widget type"), "widget_type", widget_types);
			var widget_name = this.add_token (_("Widget name"), "widget_name", "");
			var widget_folder = this.add_folder_selector_token (_("Source code folder"), "source_folder");

			this.form.get_by_name (widget_type.token_name).on_change.connect (value => {
				int _value = (int) value;
				
				print (_value.to_string ());
			});

			widget_name.validate.connect (value => {
				string _value = value.chomp ();

				widget_name.is_valid = _value.length >= 3;
			});

			widget_type.is_valid = true;
			
			widget_type.validate.connect (value => {
				widget_type.is_valid = true;
			});
		}

		public override void on_request_create () {
			string path = Path.build_filename (ElementaryTemplates.TEMPLATE_BASE_DIR, "app");
			var token = this.get_token ("source_folder");
			
			this.set_files_from_directory (File.new_for_path (path));
			
			List<File> files = FileSystemService.change_files_directory (path, token.token_value, this.parse_files_with_tokens (), true);
			
			this.write_parsed_files (files);
		}
	}
}