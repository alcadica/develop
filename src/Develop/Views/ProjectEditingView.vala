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
using Alcadica.Develop.Views.Partials.Editor;
using Alcadica.Develop.Services;
using Alcadica.LibValaProject.Entities;
using Alcadica.LibValaProject.Services;

namespace Alcadica.Develop.Views { 
	public const string CODE_EDITOR = "CODE_EDITOR";
	public const string DIRECTORIES_NAME = "DIRECTORIES_NAME";
	
	public class ProjectEditingView : Box { 
		public Alcadica.Widgets.Editor.BottomBar bottombar = new Alcadica.Widgets.Editor.BottomBar ();
		public Alcadica.Widgets.Editor.Toolbar toolbar = new Alcadica.Widgets.Editor.Toolbar ();
		public Granite.Widgets.SourceList treeview = new Granite.Widgets.SourceList ();
		public Alcadica.Develop.Views.Partials.Editor.CodeEditor editor = new Alcadica.Develop.Views.Partials.Editor.CodeEditor ();
		public Stack aside = new Stack ();
		public Stack main_content = new Stack ();

		construct {
			Paned paned = new Paned (Orientation.HORIZONTAL);
			
			aside.add_named (treeview, DIRECTORIES_NAME);
			main_content.add_named (editor, CODE_EDITOR);

			paned.pack1 (aside, false, false);
			paned.pack2 (main_content, false, false);

			paned.set_position (200);

			this.add (toolbar);
			this.add (paned);
			this.add (bottombar);
			this.orientation = Orientation.VERTICAL;

			this.toolbar.project_did_selected.connect (filepath => {
				DirectoryTreeView project_treeview = new DirectoryTreeView ();
				XMLProjectFileParser project = XMLProjectFileParser.open (filepath);

				project_treeview.show_project (project.project);

				this.treeview.root.add (project_treeview);

				if (this.treeview.root.n_children == 1) {
					project_treeview.expanded = true;
				}

				int i = 0;
				
				this.treeview.item_selected.connect (item => {
					var found_item = project_treeview.get_by_source_item_name (item.name);
					
					if (found_item != null) {
						var instance = new Plugins.Entities.Editor.TreeviewMenuContext ();

						if (found_item.project_item.nodename == NODE_DIRECTORY) {
							instance.item_type = Plugins.Entities.Editor.TreeviewMenuContextType.Folder;
						} else if (found_item.project_item.nodename == NODE_FILE) {
							instance.item_type = Plugins.Entities.Editor.TreeviewMenuContextType.File; 
						}

						instance.file = File.new_for_path (found_item.project_item.filename);
						
						Services.Editor.PluginContext.context.editor.treeview.on_select (instance);
					} else {
						warning ("Item " + item.name + " not found");
					}
				});
			});
		}
	}
}