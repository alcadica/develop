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

    public const string APP_ID = "com.github.alcadica.develop";
    public const string APP_NAME = (_("Develop"));

    public class Develop : Gtk.Application {
        public static Develop _instance = null;
        public static Develop instance {
            get {
                if (_instance == null) {
                    _instance = new Develop ();
                }
                return _instance;
            }
        }

        public Develop () {
            Object (
                application_id: APP_ID
            );
            Intl.setlocale (LocaleCategory.ALL, "");
        }

        construct {
            flags |= ApplicationFlags.HANDLES_OPEN;
        }

        protected override void activate () {
            var window = new Gtk.ApplicationWindow (this);
            var main = new Alcadica.Views.MainView ();
            var manager = Services.ActionManager.instance;
            var settings = new Services.UserSettings ();

            Services.FileSystem.window = window;

            window.set_titlebar (new Views.Partials.Window.HeaderBar ());

            window.title = APP_NAME;
            window.add (main);
            window.show_all ();
            window.set_default_size (950, 550);

            manager.get_action (Actions.Window.FIRST_RUN_END).activate.connect (() => {
                settings.is_first_run = false;
            });

            manager.get_action (Actions.Window.SETTINGS_CLOSE).activate.connect (() => {
                window.title = APP_NAME;
            });

            manager.get_action (Actions.Window.SETTINGS_OPEN).activate.connect (() => {
                window.title = APP_NAME + (" - " + (_("Preferences")));
            });

            manager.get_action (Actions.Window.QUIT).activate.connect (() => {
                window.destroy ();
            });

            manager.dispatch (Actions.Window.START);

            if (settings.is_first_run) {
                info ("first run, showing settings");
                manager.dispatch (Actions.Window.FIRST_RUN);
            }
        }

        protected override void open (File[] files, string hint) {
            activate ();
        }

        public static int main (string[] args) {
            var app = Develop.instance;
            return app.run (args);
        }
    }
}
