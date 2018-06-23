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
namespace Alcadica.Develop.Plugins.Entities {
	public class EditorContext : Object {
		public Editor.EditorList open_editors = new Editor.EditorList ();
		public Editor.TreeviewContext treeview = new Editor.TreeviewContext ();	
		public Editor.CurrentFileContext current_file = new Editor.CurrentFileContext ();
		public signal void request_open_in_new_editor (string path);

		public EditorContext () {
			request_open_in_new_editor.connect (path => {
				info (@"Selecting file $path");

				if (!open_editors.is_open_by_filename (path)) {
					info (@"Opening editor for file $path");

					open_editors.add (path);
					open_editors.on_list_change ();
				}
			});
		}
	}
}