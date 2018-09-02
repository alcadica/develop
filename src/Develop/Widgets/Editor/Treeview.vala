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
//  using Granite.Widgets;
using Alcadica.Widgets.Editor.SourceList;
using Alcadica.Develop.Services.Editor;

namespace Alcadica.Develop.Widgets.Editor {
	public class Treeview : Box {
		public Granite.Widgets.SourceList source_list { get; set; }
		public Alcadica.Develop.Plugins.Entities.Common.SourceTree source_tree { get; set; }
		
		construct {
			this.source_list = new Granite.Widgets.SourceList ();
			this.add (this.source_list);
		}

		private void bind_events (Item item, Plugins.Entities.Common.SourceTreeItem source_item) {
			var treeview_context = PluginContext.context.editor.treeview;
			
			item.action_activated.connect (() => {
				var context = this.create_context ();
				treeview_context.on_select (context);
			});
			
			item.activated.connect (() => {
				var context = this.create_context ();
				treeview_context.on_double_click (context);
			});
		}

		private Alcadica.Develop.Plugins.Entities.Editor.TreeviewMenuContext create_context () {
			return new Alcadica.Develop.Plugins.Entities.Editor.TreeviewMenuContext ();
		}

		private Item create_item (Plugins.Entities.Common.SourceTreeItem item) {
			Item source_list_item;

			if (item.is_leaf) {
				debug ("[create_item] creating leaf item " + item.node_name);
				source_list_item = new Item (item.node_name);
			} else {
				debug ("[create_item] creating folder item " + item.node_name);
				source_list_item = ((Item) new ExpandableItem (item.node_name));

				foreach (var child in item.children) {
					((ExpandableItem) source_list_item).add (this.create_item (child));
				}
			}

			source_list_item.name = item.node_name;

			this.bind_events ((Item) source_list_item, item);
			
			return source_list_item;
		}
 
		public void render () {
			ExpandableItem root = new ExpandableItem (source_tree.root.node_name);
			
			debug ("Adding items to source_list.root");

			foreach (var node in source_tree.root.children) {
				root.add (create_item (node));
			}

			this.bind_events ((Item) root, source_tree.root);
			this.source_list.root.add (root);
		}
	}
}