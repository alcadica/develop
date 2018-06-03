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
using Granite;
using Gtk;
using Alcadica.Views.Partials.Editor;
using Alcadica.Services;
using Alcadica.LibValaProject.Services;

namespace Alcadica.Views { 
	public const string DIRECTORIES_NAME = "DIRECTORIES_NAME";
	
	public class ProjectEditingView : Box { 
		public Alcadica.Widgets.Editor.Toolbar toolbar = new Alcadica.Widgets.Editor.Toolbar ();
		public Granite.Widgets.SourceList treeview = new Granite.Widgets.SourceList ();
		public Stack aside = new Stack ();
		public Stack editor = new Stack ();

		construct {
			Paned paned = new Paned (Orientation.HORIZONTAL);
			
			aside.add_named (treeview, DIRECTORIES_NAME);

			paned.pack1 (aside, false, false);
			//  paned.pack2 (editor, false, false);

			this.add (toolbar);
			this.pack_end (paned);
			this.orientation = Orientation.VERTICAL;

			this.toolbar.project_did_selected.connect (filepath => {
				DirectoryTreeView project_treeview = new DirectoryTreeView ();
				XMLProjectFileParser project = XMLProjectFileParser.open (filepath);

				project_treeview.show_project (project.project);

				this.treeview.root.add (project_treeview);

				if (this.treeview.root.n_children == 1) {
					project_treeview.expanded = true;
				}
			});
		}
	}
}