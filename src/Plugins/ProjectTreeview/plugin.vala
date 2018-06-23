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

using Alcadica.Develop.Plugins;

[ModuleInit]
public static Type plugin_init (GLib.TypeModule type_module) {
	return typeof (com.alcadica.develop.plugins.Treeview);
}

namespace com.alcadica.develop.plugins {
	public class Treeview : Plugin {
		
		public override string get_name () {
			return "com.alcadica.develop.plugins.Treeview";
		}
		
		public override void activate (Entities.PluginContext context) {
			TreeviewHandlers.plugin_context = context;

			context.editor.treeview.on_double_click.connect (TreeviewHandlers.handle_double_click);
			context.editor.treeview.on_select.connect (TreeviewHandlers.handle_file_select);
			context.editor.treeview.on_file_right_click.connect (TreeviewHandlers.handle_menu_file_right_click);
			context.editor.treeview.on_folder_right_click.connect (TreeviewHandlers.handle_menu_folder_right_click);
		}

		public override void deactivate (Entities.PluginContext context) {
			context.editor.treeview.on_double_click.disconnect (TreeviewHandlers.handle_double_click);
			context.editor.treeview.on_file_right_click.disconnect (TreeviewHandlers.handle_menu_file_right_click);
			context.editor.treeview.on_folder_right_click.disconnect (TreeviewHandlers.handle_menu_folder_right_click);
			context.editor.treeview.on_select.disconnect (TreeviewHandlers.handle_file_select);
		}
		
		public override void registered () {
			info ("Hello darkness my old friend...");
		}

		public override void unregistered () {
			this.dispose ();
		}
	}
}