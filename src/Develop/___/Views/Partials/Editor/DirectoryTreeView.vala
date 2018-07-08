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

using Alcadica.LibValaProject.Entities;
using Granite.Widgets;

namespace Alcadica.Develop.Views.Partials.Editor { 
	protected class DirectoryTreeViewItem {
		public ProjectItem project_item { get; set; }
		public SourceList.Item source_item { get; set; }
	}
	
	public class DirectoryTreeView : SourceList.ExpandableItem {
		public Project project { get; set; }
		public SourceList root = new SourceList ();
		public List<DirectoryTreeViewItem> project_tree = new List<DirectoryTreeViewItem> ();

		protected DirectoryTreeViewItem? get_by_name (string? name) {
			DirectoryTreeViewItem? item = null;

			if (name == null) {
				return item;
			}

			for (int a = 0; a < this.project_tree.length (); a++) {
				var found = this.project_tree.nth_data (a);

				if (found.project_item.nodepath == name) {
					item = found;
					break;
				}
			}
			
			return item;
		}

		protected void render_nodes (ProjectItem node) {
			if (node == null || !node.has_children) {
				return;
			}

			SourceList.ExpandableItem parent;
			var _item = this.get_by_name (node.nodepath);

			if (_item != null) {
				parent = _item.source_item as SourceList.ExpandableItem;				
			} else {
				parent = this;
			}
			
			for (int i = 0; i < node.length; i++) {
				DirectoryTreeViewItem? current = this.get_by_name (node.get_child (i).nodepath);

				if (current != null) {
					parent.add (current.source_item);
					this.render_nodes (current.project_item);
				}
			}
		}

		protected void reset_tree () {
			this.project_tree = new List<DirectoryTreeViewItem> ();	
		}

		public DirectoryTreeViewItem? get_by_source_item_name (string? name) {
			DirectoryTreeViewItem? item = null;

			if (name == null) {
				return item;
			}

			for (int a = 0; a < this.project_tree.length (); a++) {
				var found = this.project_tree.nth_data (a);

				if (found.source_item.name == name) {
					item = found;
					break;
				}
			}
			
			return item;
		}

		public void show_project (Project project) {
			var children = project.sources.get_flatterned_children ();
			var plugin_context = Services.Editor.PluginContext.context;
			
			this.project = project;
			this.name = project.project_name + " - " + project.version.to_string ();

			foreach (var child in children) {
				DirectoryTreeViewItem item = new DirectoryTreeViewItem ();
				string icon_name = "";

				item.project_item = child;
				
				if (child.nodename == NODE_DIRECTORY) {
					item.source_item = new Alcadica.Widgets.Editor.SourceList.ExpandableItem (child.friendlyname);
					icon_name = "folder";
				} else if (child.nodename == NODE_FILE) {
					item.source_item = new Alcadica.Widgets.Editor.SourceList.Item (child.friendlyname);
					icon_name = "text-x-vala";
				}

				item.source_item.activated.connect (() => {
					var context = new Plugins.Entities.Editor.TreeviewMenuContext ();

					context.file = File.new_for_path (child.filename);

					if (child.nodename == NODE_DIRECTORY) {
						context.item_type = Plugins.Entities.Editor.TreeviewMenuContextType.Directory;
					} else if (child.nodename == NODE_FILE) {
						context.item_type = Plugins.Entities.Editor.TreeviewMenuContextType.File;
					}
					
					plugin_context.editor.treeview.on_double_click (context);
				});
				
				item.source_item.icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.BUTTON).gicon;
				
				this.project_tree.append (item);
			}
			
			this.render_nodes (project.sources);
		}
	}
}
