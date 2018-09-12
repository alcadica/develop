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
		public static string domain = "filesystem";

		protected static void add_directory (Entities.Editor.TreeviewMenuContext context) {
			plugin_context.editor.treeview.request_add_new_directory (context);
		}

		protected static void edit_file (Entities.Editor.TreeviewMenuContext context) {
			handle_file_select (context);			
		}

		protected static void new_file (Entities.Editor.TreeviewMenuContext context) {
			plugin_context.editor.treeview.request_add_new_file (context);
		}

		protected static void remove_directory (Entities.Editor.TreeviewMenuContext context) {
			plugin_context.editor.treeview.request_remove_directory (context);
		}

		protected static void remove_file (Entities.Editor.TreeviewMenuContext context) {
			plugin_context.editor.treeview.request_remove_file (context);
		}

		public static void handle_double_click (Entities.Editor.TreeviewMenuContext context) {
			if (!context.is_domain_acceptable (domain)) {
				return;
			}
			
			if (context.item_type == Entities.Editor.TreeviewMenuContextType.File) {
				plugin_context.editor.request_open_in_new_editor (context.file.get_path ());
			} else if (context.item_type == Entities.Editor.TreeviewMenuContextType.Directory) {
				plugin_context.editor.treeview.request_toggle_directory (context.file.get_path ());
			}
		}
		
		public static void handle_file_select (Entities.Editor.TreeviewMenuContext context) {
			if (!context.is_domain_acceptable (domain)) {
				return;
			}
		}
		
		public static void handle_menu_file_right_click (Entities.Editor.TreeviewMenuContext context) {
			debug (context.domain);

			if (!context.is_domain_acceptable (domain)) {
				return;
			}
			
			context.add_item (_("Edit file")).activate.connect (() => { 
				edit_file (context); 
			});
			context.add_item (_("Rename file")).activate.connect (() => { 
				plugin_context.editor.treeview.request_rename_file (context); 
			});
			context.add_item (_("Remove file")).activate.connect (() => { 
				remove_file (context); 
			});
		}

		public static void handle_menu_folder_right_click (Entities.Editor.TreeviewMenuContext context) {
			debug (context.domain);
			
			if (!context.is_domain_acceptable (domain)) {
				return;
			}
			
			context.add_item (_("Add folder")).activate.connect (() => { 
				add_directory (context); 
			});
			context.add_item (_("New file")).activate.connect (() => { 
				new_file (context); 
			});
			context.add_item (_("Rename folder")).activate.connect (() => { 
				plugin_context.editor.treeview.request_rename_directory (context); 
			});
			context.add_item (_("Remove folder")).activate.connect (() => { 
				remove_directory (context); 
			});
		}
	}
}