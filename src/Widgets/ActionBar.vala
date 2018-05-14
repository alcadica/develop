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

namespace Alcadica.Widgets {
    public class ActionBar : Gtk.Grid {
        public Button primary_action { get; set; }
        public Button secondary_action { get; set; }

        construct {
            this.expand = true;
            this.orientation = Orientation.HORIZONTAL;
            this.primary_action = new Button.with_label (_("Create"));
            this.secondary_action = new Button.with_label (_("Undo"));
            this.add (this.secondary_action);
            this.add (this.primary_action);
            this.set_column_homogeneous (true);

            this.primary_action.get_style_context ().add_class (STYLE_CLASS_SUGGESTED_ACTION);
        }

        public void disable () {
            this.disable_primary_action ();
            this.disable_secondary_action ();
        }

        public void enable () {
            this.enable_primary_action ();
            this.enable_secondary_action ();
        }

        public void toggle (bool value) {
            this.toggle_primary_action (value);
            this.toggle_secondary_action (value);
        }

        public void disable_primary_action () {
            this.primary_action.set_sensitive (false);
        }

        public void enable_primary_action () {
            this.primary_action.set_sensitive (true);
        }

        public void toggle_primary_action (bool value) {
            this.primary_action.set_sensitive (value);
        }

        public void disable_secondary_action () {
            this.secondary_action.set_sensitive (false);
        }

        public void enable_secondary_action () {
            this.secondary_action.set_sensitive (true);
        }

        public void toggle_secondary_action (bool value) {
            this.secondary_action.set_sensitive (value);
        }
    }
}