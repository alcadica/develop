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

namespace com.alcadica.develop.plugins {
	public class TreeviewHandlers : Object {
		public static Entities.PluginContext plugin_context { get; set; }

		protected static void add_folder () { }

		protected static void edit_file () { }

		protected static void new_file () { }

		protected static void remove_file () { }

		protected static void remove_folder () { }

		public static void handle_double_click (Entities.Editor.TreeviewMenuContext context) {
			if (context.item_type == Entities.Editor.TreeviewMenuContextType.File) {
				plugin_context.editor.request_open_in_new_editor (context.file.get_path ());
			}
		}
		
		public static void handle_file_select (Entities.Editor.TreeviewMenuContext context) {
			if (context.item_type == Entities.Editor.TreeviewMenuContextType.File) {
				plugin_context.editor.request_open_in_new_editor (context.file.get_path ());
			}
		}
		
		public static void handle_menu_file_right_click (Entities.Editor.TreeviewMenuContext context) {
			context.add_item ("Edit file").activate.connect (edit_file);
			context.add_item ("Remove file").activate.connect (remove_file);
		}

		public static void handle_menu_folder_right_click (Entities.Editor.TreeviewMenuContext context) {
			context.add_item ("Add folder").activate.connect (add_folder);
			context.add_item ("New file").activate.connect (new_file);
			context.add_item ("Remove folder").activate.connect (remove_folder);
		}
	}
}