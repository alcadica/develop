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
using Granite.Widgets;
using Gtk;

namespace Alcadica.Develop.Widgets.Window {
	public class HeaderBar : Gtk.HeaderBar {
		construct {
			Button button_back = new Button.with_label (_("Back"));
			Button button_settings = new Button.from_icon_name ("open-menu");
			
			button_back.get_style_context().add_class (STYLE_CLASS_BACK_BUTTON);
			//  STYLE_CLASS_BACK_BUTTON
			var css_context = this.get_style_context ();
			css_context.add_class ("input-header");
			css_context.add_class ("titlebar");
			css_context.add_class ("default-decoration");
			css_context.add_class (Gtk.STYLE_CLASS_FLAT);

			this.show_close_button = true;
			this.pack_start (button_back);
			this.pack_end (button_settings);

			var manager = Alcadica.Develop.Services.ActionManager.instance;

			button_back.clicked.connect (() => {
				Services.Editor.PluginContext.context.application.show_editors();
			});

			button_settings.clicked.connect(() => {
				Services.Editor.PluginContext.context.application.show_settings ();
			});

			manager.get_action (Actions.Window.START).activate.connect (() => {
				button_back.hide ();
			});

			manager.get_action (Actions.Window.FIRST_RUN).activate.connect (() => {
				button_settings.hide ();
			});

			manager.get_action (Actions.Window.FIRST_RUN_END).activate.connect (() => {
				button_settings.show ();
			});
			
			Services.Editor.PluginContext.context.application.show_editors.connect (() => {
				button_back.hide ();
			});

			Services.Editor.PluginContext.context.application.show_settings.connect (() => {
				button_back.show ();
			});

			Services.Editor.PluginContext.context.application.show_templates.connect (() => {
				button_back.show ();
			});
		}
	}
}