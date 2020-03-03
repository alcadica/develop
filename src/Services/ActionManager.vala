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
namespace Alcadica.Services {
    public class ActionManager : Object {
        private static ActionManager _instance = null;

        public static ActionManager instance {
            get {
                if (_instance == null) {
                    _instance = new ActionManager ();
                }
                return _instance;
            }
        }

        public SimpleActionGroup action_group { get; construct; }

        private ActionManager () {
            Object (
                action_group: new SimpleActionGroup ()
            );
        }

        public void add (string name) {
            SimpleAction action = new SimpleAction (name, null);
            this.action_group.add_action (action);
        }

        public SimpleAction get_action (string name) {
            if (!this.action_group.has_action (name)) {
                this.add (name);
            }

            return this.action_group.lookup_action (name) as SimpleAction;
        }

        public void dispatch (string name) {
            this.action_group.activate_action (name, null);
        }

        public void remove (string name) {
            this.action_group.remove_action (name);
        }
    }
}
