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
using Granite.Widgets;
using Alcadica.Develop.Services.Editor;

namespace Alcadica.Develop.Widgets.Editor {
	public class Treeview : Box {
		public Granite.Widgets.SourceList source_list { get; set; }
		public Alcadica.Develop.Plugins.Entities.Common.SourceTree source_tree { get; set; }
		
		construct {
			this.source_list = new Granite.Widgets.SourceList ();
			this.add (this.source_list);
		}

		private SourceList.ExpandableItem create_parent_item (Plugins.Entities.Common.SourceTreeItem item) {
			debug ("[create_item] creating folder item " + item.node_name);
			SourceList.ExpandableItem source_list_item = new SourceList.ExpandableItem ();

			source_list_item.name = item.node_name;

			if (item.children.length () > 0) {
				foreach (var child in item.children) {
					if (child.is_leaf) {
						source_list_item.add (this.create_leaf_item (child));
					} else {
						source_list_item.add (this.create_parent_item (child));
					}
				}
			}

			return source_list_item;
		}

		private SourceList.Item create_leaf_item (Plugins.Entities.Common.SourceTreeItem item) {
			debug ("[create_item] creating leaf item " + item.node_name);
			var list_item = new SourceList.Item ();

			list_item.name = item.node_name;
			
			return list_item;
		}
 
		public void render () {
			SourceList.ExpandableItem root = new SourceList.ExpandableItem (source_tree.root.node_name);
			
			debug ("Adding items to source_list.root");

			foreach (var node in source_tree.root.children) {
				if (node.is_leaf) {
					root.add (create_leaf_item (node));
				} else {
					root.add (create_parent_item (node));
				}
			}

			this.source_list.root.add (root);
		}
	}
}