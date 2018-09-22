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
using Alcadica.Develop.Plugins.Entities;

namespace Alcadica.Develop.Widgets.Editor {
	public static Gtk.Menu? _get_context_menu (bool is_directory, string item_domain, Plugins.Entities.Common.SourceTreeItem tree_item) {
		var menu_context = new Alcadica.Develop.Plugins.Entities.Editor.TreeviewMenuContext ();
		var treeview_context = Services.Editor.PluginContext.context.editor.treeview;

		menu_context.domain = item_domain;
		menu_context.source_tree_item = tree_item;

		if (is_directory) {
			treeview_context.on_folder_right_click (menu_context);
		} else {
			treeview_context.on_file_right_click (menu_context);
		}

		if (menu_context.items.length () == 0) {
			return null;
		}

		var menu = new Gtk.Menu();

		foreach (var item in menu_context.items) {
			Gtk.MenuItem menu_item = new Gtk.MenuItem.with_label (item.label);

			menu_item.activate.connect (() => item.activate(tree_item));

			menu.add (menu_item);
		}

		menu.show_all ();
		
		return menu;
	}
	
	protected class TreeviewItem : Granite.Widgets.SourceList.Item {
		public string item_domain { get; set; }
		public Plugins.Entities.Common.SourceTreeItem source_tree_item { get; set; }
		public override Gtk.Menu? get_context_menu () {
			return _get_context_menu (false, item_domain, source_tree_item);
		}
	}

	protected class TreeviewParentItem : SourceList.ExpandableItem {
		public string item_domain { get; set; }
		public Plugins.Entities.Common.SourceTreeItem source_tree_item { get; set; }
		public override Gtk.Menu? get_context_menu () {
			return _get_context_menu (true, item_domain, source_tree_item);
		}
	}
	
	public class Treeview : Box {
		public Granite.Widgets.SourceList source_list { get; set; }
		public Alcadica.Develop.Plugins.Entities.Common.SourceTree source_tree { get; set; }
		
		construct {
			this.source_list = new Granite.Widgets.SourceList ();
			this.add (this.source_list);
		}

		private SourceList.ExpandableItem create_parent_item (Plugins.Entities.Common.SourceTreeItem item) {
			debug ("[create_item] creating folder item " + item.node_name);
			var source_list_item = new TreeviewParentItem ();

			source_list_item.name = item.node_name;
			source_list_item.item_domain = item.domain;
			source_list_item.source_tree_item = item;

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
			var list_item = new TreeviewItem ();

			list_item.name = item.node_name;
			list_item.item_domain = item.domain;
			list_item.source_tree_item = item;
			
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