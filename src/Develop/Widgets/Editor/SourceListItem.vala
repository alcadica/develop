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

			Gtk.MenuItem item_create_class = new Gtk.MenuItem.with_label ("Add new class");
			Gtk.MenuItem item_rename = new Gtk.MenuItem.with_label ("Rename");
			Gtk.MenuItem item_remove = new Gtk.MenuItem.with_label ("Remove");

			menu.add (item_create_class);
			menu.add (new Gtk.SeparatorMenuItem ());
			menu.add (item_rename);
			menu.add (item_remove);

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

			Gtk.MenuItem item_rename = new Gtk.MenuItem.with_label ("Rename");
			Gtk.MenuItem item_remove = new Gtk.MenuItem.with_label ("Remove");

			menu.add (item_rename);
			menu.add (item_remove);

			menu.show_all ();
			
			return menu;
		}
	}
}