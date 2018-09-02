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
using Alcadica.Develop.Services.Editor;
using Alcadica.Develop.Plugins.Entities.Common;

namespace Alcadica.Develop.Widgets.Editor {
	public class Aside : Gtk.Box {
		private HashTable<string, Treeview> treeview_table = new HashTable<string, Treeview> (direct_hash, direct_equal);
		
		construct {
			var project_context = PluginContext.context.project;
			var treeview_context = PluginContext.context.editor.treeview;
			
			this.orientation = Gtk.Orientation.VERTICAL;

			project_context.project_did_open.connect (project => {
				debug ("Subscribing " + project.project_name + " tree");
				treeview_context.subscribe_treeview (project.tree);
			});

			treeview_context.on_treeview_subscribe.connect (treeview => {
				Treeview treeview_widget = new Treeview ();
				string treename = treeview.root.node_name;

				debug (@"A treeview name $treename did subscribe.");

				treeview_widget.source_tree = treeview;
				
				this.treeview_table.insert (treename, treeview_widget);

				debug (@"Rendering treeview $treename");

				treeview_widget.render ();

				debug (@"Adding $treename tree to view");

				this.add (treeview_widget);
				this.show_all ();
			});

			treeview_context.on_treeview_unsubscribe.connect (treeview => {
				debug ("Treeview " + treeview.root.node_name + " did unsubscribe");
				
				Treeview treeview_widget = this.treeview_table.get (treeview.root.node_name);
				
				if (treeview_widget != null) {
					debug ("Disponing treeview " + treeview.root.node_name);
					treeview_widget.dispose ();
				}
			});
		}
	}
}