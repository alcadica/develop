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

using Alcadica.Entities.Project;
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

		public void show_project (Project project) {
			this.project_name.label = project.project_name + " - " + project.version.to_string ();

			project.sources.children_foreach (TraverseFlags.ALL, node => {
				if (node == null) {
					continue;
				}
				
				if (node.data<ProjectItem>.nodename == "directory") {

				} else if (node.data.nodename == "file") {

				}
			});
		}
	}
}