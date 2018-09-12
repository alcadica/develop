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

namespace Alcadica.Widgets.Editor.SourceList {

	public class ExpandableItem : Granite.Widgets.SourceList.ExpandableItem {
		
		public ExpandableItem (string name) {
			Object (
				name: name
			);
		}
		
		public override Gtk.Menu? get_context_menu () {
			Gtk.Menu menu = new Gtk.Menu ();

			var context = new Develop.Plugins.Entities.Editor.TreeviewMenuContext ();

			Develop.Services.Editor.PluginContext.context.editor.treeview.on_folder_right_click (context);
			
			foreach (var item in context.items) {
				Gtk.MenuItem menu_item = new Gtk.MenuItem.with_label (item.label);

				menu_item.activate.connect (() => item.activate ());
				
				menu.add (menu_item);
			}

			menu.show_all ();
			
			return menu;
		}
	}
	
	public class Item : Granite.Widgets.SourceList.Item {

		public Item (string name) {
			Object (
				name: name
			);
		}
		
		public override Gtk.Menu? get_context_menu () {
			Gtk.Menu menu = new Gtk.Menu ();

			var context = new Develop.Plugins.Entities.Editor.TreeviewMenuContext ();
			
			Develop.Services.Editor.PluginContext.context.editor.treeview.on_file_right_click (context);

			foreach (var item in context.items) {
				Gtk.MenuItem menu_item = new Gtk.MenuItem.with_label (item.label);

				menu_item.activate.connect (() => item.activate ());
				
				menu.add (menu_item);
			}

			menu.show_all ();
			
			return menu;
		}
	}
}