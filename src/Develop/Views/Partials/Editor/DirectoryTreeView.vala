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

namespace Alcadica.Views.Partials.Editor { 
	public class DirectoryTreeView : Gtk.Grid {
		public Gtk.Label project_name = new Gtk.Label (null);
		public SourceList root = new SourceList ();
		public SourceList.ExpandableItem sources { get; set; }

		construct {
			this.orientation = Gtk.Orientation.VERTICAL;
			
			this.sources = new SourceList.ExpandableItem (_("Sources"));

			this.root.root.add (this.sources);
			
			this.add (this.project_name);
			this.add (this.root);

			this.sources.expanded = true;
		}

		protected void render_nodes (Node<ProjectItem> node) {
			if (node.n_children () == 0) {
				return;
			}

			for (int i = 0; i < node.n_children (); i++) {
				unowned Node<ProjectItem> current = node.nth_child (i);

				if (current != null && current.data.nodename == "directory") {
					this.sources.add (new SourceList.ExpandableItem (current.data.friendlyname));
				} else if (current != null && current.data.nodename == "file") {
					this.sources.add (new SourceList.Item (current.data.friendlyname));
				}

				print (current.data.friendlyname);

				this.render_nodes (current);
			}
		}

		public void show_project (Project project) {
			this.project_name.label = project.project_name + " - " + project.version.to_string ();
			this.render_nodes (project.sources);
		}
	}
}
