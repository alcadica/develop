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
    public class SwitchWithLabel : Grid {
        public Switch entry { get; set; }
        public Label label { get; set; }
        public signal void changed (bool is_active);
        public bool active {
            get {
                return this.entry.active;
            }
            set {
                this.entry.active = value;
            }
        }
        public bool editable {
            get {
                return this.entry.get_sensitive ();
            }
            set {
                this.entry.set_sensitive (value);
            }
        }

        public SwitchWithLabel (string entry_label) {
            this.entry = new Switch ();
            this.label = new Label (entry_label);

            this.label.set_xalign (0);
            this.orientation = Orientation.HORIZONTAL;
            this.row_spacing = 4;

            this.add (this.entry);
            this.add (this.label);
            this.set_expand (true);

            this.entry.activate.connect (() => {
                this.changed (this.entry.active);
            });
        }

        public void focusin () {
            this.entry.grab_focus ();
        }

        public void set_expand (bool expand) {
            this.expand = true;
            this.entry.expand = expand;
            this.label.expand = expand;
        }

        public void set_xalign (int align) {
            this.label.set_xalign (align);
        }
    }
}
