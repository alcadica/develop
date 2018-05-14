/*
 * Copyright (c) {{yearrange}} {{name}}. ({{site}})
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
 * Boston, MA 02110-1301 USA.
*
* Authored by: {{name}} <{{site}}>
 */

namespace {{projectname}} {
    public class Plug : Switchboard.Plug {

        public Plug () {
            var settings = new Gee.TreeMap<string, string?> (null, null);
            Object (category: {{plugincategoryid}},
                    code_name: "{{plugincategory}}-{{projectname}}",
                    display_name: _("{{plugdisplayname}}"),
                    description: _("{{plugdescription}}"),
                    icon: "{{execname}}",
                    supported_settings: settings);
        }

        public override Gtk.Widget get_widget () {
            var settings = new {{projectname}}.Backend.Settings ();
            var widget = new {{projectname}}.Widgets.GeneralSection (settings);

            load_settings ();
            
            return widget;
        }

        public override void shown () {
        }

        public override void hidden () {
        }

        public override void search_callback (string location) {
        }

        public override async Gee.TreeMap<string, string> search (string search) {
            return new Gee.TreeMap<string, string> (null, null);
        }

        private void load_settings () {
        }
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating {{projectname}} plug");

    var plug = new {{projectname}}.Plug ();

    return plug;
}
