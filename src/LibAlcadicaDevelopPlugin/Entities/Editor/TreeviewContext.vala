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
namespace Alcadica.Develop.Plugins.Entities.Editor {
	public class TreeviewContext {
		public List<Common.SourceTree> treeview = new List<Common.SourceTree> ();
		public signal void on_double_click (TreeviewMenuContext context);
		public signal void on_right_click (TreeviewMenuContext context);
		public signal void on_file_right_click (TreeviewMenuContext context);
		public signal void on_folder_right_click (TreeviewMenuContext context);
		public signal void on_select (TreeviewMenuContext context);
		public signal void on_treeview_subscribe (Common.SourceTree treeview);
		public signal void on_treeview_unsubscribe (Common.SourceTree treeview);
		public signal void request_add_new_directory (TreeviewMenuContext context);
		public signal void request_add_new_file (TreeviewMenuContext context);
		public signal void request_close_directory (string directory_name);
		public signal void request_open_directory (string directory_name);
		public signal void request_remove_directory (TreeviewMenuContext context);
		public signal void request_remove_file (TreeviewMenuContext context);
		public signal void request_rename_directory (TreeviewMenuContext context);
		public signal void request_rename_file (TreeviewMenuContext context);
		public signal void request_toggle_directory (string directory_name);
		public signal void refresh ();

		public TreeviewContext () {
			this.refresh.connect (() => {
				foreach (var treeview in this.treeview) {
					treeview.tree_did_change ();
				}
			});
		}
		
		public void subscribe_treeview (Common.SourceTree treeview) {
			this.treeview.append (treeview);
			this.on_treeview_subscribe (treeview);
		}

		public void unsubscribe_treeview (Common.SourceTree treeview) {
			this.treeview.remove (treeview);
			this.on_treeview_unsubscribe (treeview);
		}
	}
}