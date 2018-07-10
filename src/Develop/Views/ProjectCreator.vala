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
using Gtk;

using Alcadica.Develop.Services.Editor;

namespace Alcadica.Develop.Views { 
	public class ProjectCreator : Grid {
		private Grid templates_grid;
		private int _rows_num = 0;
		
		construct {
			var manager = Services.ActionManager.instance;

			this.column_homogeneous = true;
			this.column_spacing = 12;
			this.row_spacing = 12;
			this.orientation = Orientation.VERTICAL;
			this.templates_grid = new Grid ();
			this.add (this.templates_grid);

			manager.get_action (Actions.Window.SHOW_PROJECT_CREATION).activate.connect (() => {
				this.empty_grid ();
				this.populate_template_list ();
				this.show_all ();
			});
		}

		private void empty_grid () {
			int removed_rows = 0;

			while (removed_rows < _rows_num) {
				this.templates_grid.remove_row (removed_rows);
				removed_rows += 1;
			}

			this._rows_num = 0;
		}

		private Widget? get_list_item (string item_name) {
			var template = PluginContext.context.template.get_template_by_name (item_name);
			
			if (template == null) {
				debug (@"No instance for template $item_name");
				return null;
			}

			string template_icon_name;

			if (template.template_icon_name == "" || template.template_icon_name == null) {
				template_icon_name = "image-missing";
			} else {
				template_icon_name = template.template_icon_name;
			}
			
			var grid = new Grid ();
			var template_description = new Label (template.template_description);
			var template_icon = new Image.from_icon_name (template_icon_name, IconSize.DIALOG);
			var template_name = new Label (template.template_name);

			template_name.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
			template_name.ellipsize = Pango.EllipsizeMode.END;
			template_name.xalign = 0;
			template_name.valign = Gtk.Align.END;

			grid.column_spacing = 12;
			grid.orientation = Orientation.HORIZONTAL;
			grid.attach (template_icon, 0, 0, 1, 2);
			grid.attach (template_name, 1, 0, 1, 1);
			grid.attach (template_description, 1, 1, 1, 1);

			debug (@"Created template list item $item_name");

			return grid;
		}

		private void populate_template_list () {
			List<string> subscribed_templates = PluginContext.context.template.get_subscribed_templates_names ();
			
			foreach (var template_name in subscribed_templates) {
				debug (@"Adding \"$template_name\" to templates list.");

				Widget? item = this.get_list_item (template_name);

				if (item == null) {
					continue;
				}
				
				this.templates_grid.attach (item, 0, this._rows_num);
				this._rows_num += 1;
			}
		}
	}
}