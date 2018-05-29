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

namespace Alcadica { 
	public class Window : Gtk.Window {
		public Views.Partials.Window.HeaderBar header { get; set; }
		public Views.MainView content { get; set; }
		
		public Window (Gtk.Application app) {
			Object (
				application: app,
				icon_name: APP_ID,
				title: APP_NAME
			);
		}

		construct {
			Services.FileSystem.window = this as Gtk.ApplicationWindow;
			
			this.build_ui ();
			this.show_all ();

			this.set_default_size (750, 550);
			
			this.init_actions ();
			this.init_accelerators ();
		}

		protected void build_ui () {
			this.content = new Alcadica.Views.MainView ();
			this.header = new Views.Partials.Window.HeaderBar ();

			this.set_titlebar (this.header);
			this.add (this.content);
		}

		protected void init_accelerators () {

		}

		protected void init_actions () {
			Services.ActionManager action_manager = Services.ActionManager.instance;
			Services.UserSettings settings = new Services.UserSettings ();
			
            action_manager.get_action (Actions.Window.FIRST_RUN_END).activate.connect (() => {
                settings.is_first_run = false;
            });

            action_manager.get_action (Actions.Window.SETTINGS_CLOSE).activate.connect (() => {
                this.title = APP_NAME;
            });

            action_manager.get_action (Actions.Window.SETTINGS_OPEN).activate.connect (() => {
                this.title = APP_NAME + " - Preferences";
            });

            action_manager.get_action (Actions.Window.QUIT).activate.connect (() => {
                this.destroy ();
            });

            action_manager.dispatch (Actions.Window.START);

            if (settings.is_first_run) {
                info ("first run, showing settings");
				action_manager.dispatch (Actions.Window.FIRST_RUN);
			}
			
			action_manager.dispatch (Actions.Window.EDITOR_OPEN);
		}
	}
}