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

namespace Alcadica.Develop.Plugins.Entities.Project {
	public class ProjectSourceTree : Common.SourceTree {
		public bool add_path (string path, Common.SourceTreeItem? add_to_node = null) {
			string[] chunks = path.split ("/");
			Common.SourceTreeItem current_node;

			if (add_to_node == null) {
				current_node = root;
			} else {
				current_node = add_to_node;
			}

			debug ("[ProjectSourceTree] adding " + chunks.length.to_string () + " nodes");

			for (int i = 0; i < chunks.length; i++) {
				Common.SourceTreeItem new_node = new Common.SourceTreeItem ();
				string chunk = chunks[i];

				debug ("[ProjectSourceTree] adding new node with path " + chunk);

				new_node.node_name = chunk;

				current_node.append_child (new_node);
				current_node = new_node;
			}
			
			return true;
		}
	}
}