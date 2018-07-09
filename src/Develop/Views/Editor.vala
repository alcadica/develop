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

namespace Alcadica.Develop.Views { 
	public class Editor : Gtk.Box {
		construct {
			var aside = new Alcadica.Develop.Widgets.Editor.Aside ();
			var bottom_bar = new Alcadica.Develop.Widgets.Editor.BottomBar ();
			var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
			var scrolled_window = new Gtk.ScrolledWindow (null, null);
			var source_grid = new Gtk.Grid ();
			var source_view = new Alcadica.Develop.Widgets.Editor.SourceView ();
			var toolbar = new Alcadica.Develop.Widgets.Editor.Toolbar ();

			scrolled_window.add (source_view);
			scrolled_window.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;

			source_grid.add(scrolled_window);

			paned.pack1 (aside, false, true);
			paned.pack2 (source_grid, false, false);
			paned.set_position (200);

			source_grid.add(source_view);

			this.pack_start (toolbar, false, false);
			this.add (paned);
			this.pack_end (bottom_bar, false, false);
			this.orientation = Gtk.Orientation.VERTICAL;
			this.show_all ();
		}
	}
}