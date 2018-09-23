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
		private string assets_name = "assets";
		private string empty_name = "empty_editor";
		private string editor_name = "editor";
		
		construct {
			var aside = new Alcadica.Develop.Widgets.Editor.Aside ();
			var aside_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
			var assets = new Alcadica.Develop.Widgets.Editor.Assets ();
			var bottom_bar = new Alcadica.Develop.Widgets.Editor.BottomBar ();
			var editor_scrolled_window = new Gtk.ScrolledWindow (null, null);
			var empty_editor = new Alcadica.Develop.Widgets.Editor.EmptyEditor ();
			var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
			var source_stack = new Gtk.Stack ();
			var source_view = new Alcadica.Develop.Widgets.Editor.SourceView ();
			var toolbar = new Alcadica.Develop.Widgets.Editor.Toolbar ();

			editor_scrolled_window.add (source_view);
			editor_scrolled_window.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;

			source_stack.add_named(empty_editor, empty_name);
			source_stack.add_named(assets, assets_name);
			source_stack.add_named(editor_scrolled_window, editor_name);
			source_stack.set_homogeneous (true);

			aside_box.add (toolbar);
			aside_box.add (aside);

			paned.pack1 (aside_box, false, true);
			paned.pack2 (source_stack, false, false);
			paned.set_position (200);

			this.pack_start (toolbar, false, false);
			this.pack_start (paned, false, true);
			this.pack_end (bottom_bar, false, false);
			this.orientation = Gtk.Orientation.VERTICAL;
			this.show_all ();

			Services.ActionManager.instance.get_action (Actions.Window.SHOW_ASSETS_MANAGER).activate.connect (() => {
				source_stack.set_visible_child_full (assets_name, Gtk.StackTransitionType.OVER_DOWN);
			});

			Services.ActionManager.instance.get_action (Actions.Window.SHOW_PREVIOUS_EDITOR_VIEW).activate.connect (() => {
				source_stack.set_visible_child_full (empty_name, Gtk.StackTransitionType.UNDER_UP);
			});
		}
	}
}