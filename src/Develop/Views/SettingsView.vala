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
using Alcadica.Views.Partials;
using Alcadica.Widgets;

namespace Alcadica.Views {
    
    public class SettingsView : Paned {
		public Stack stack_content = new Stack ();
		public Box stack_menu = new Box (Orientation.VERTICAL, 0);
		public Partials.Settings.UserDataSettings form_user = new Partials.Settings.UserDataSettings ();

		construct {
			ListBox listbox = new ListBox();
			SettingItem button_form_user = new SettingItem (_("User settings"), _("Sets your personal developer data"), "office-contact");

			listbox.selection_mode = Gtk.SelectionMode.SINGLE;
			
			this.pack1 (this.stack_menu, true, true);
			this.pack2 (this.stack_content, true, true);
			this.set_position (220);

			this.stack_content.add (this.form_user);
			this.stack_menu.add (listbox);

			listbox.add(button_form_user);

			stack_content.margin = 10;
		}
	}
}