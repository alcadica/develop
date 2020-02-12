/*-
 * Copyright (c) {{yearrange}} {{name}} ({{site}})
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: {{name}} <{{site}}>
 */

public class {{projectname}}.Indicator : Wingpanel.Indicator {
    private Gtk.Grid main_grid;
    private Gtk.Image display_icon;

    public Indicator () {
        Object (code_name: "",
                display_name: _("{{projectname}}"),
                description:_("{{indicatordescription}}"));
        this.display_icon = new Gtk.Image.from_icon_name ("{{execname}}", Gtk.IconSize.MENU);
    }

    public override Gtk.Widget get_display_widget () {
        if (display_icon == null) {
            // TODO
        }

        return display_icon;
    }

    public override Gtk.Widget? get_widget () {
        if (main_grid == null) {
            main_grid = new Gtk.Grid ();
            main_grid.set_orientation (Gtk.Orientation.VERTICAL);

            main_grid.show_all ();
        }

        return main_grid;
    }

    public override void opened () { }

    public override void closed () { }
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    // Temporal workarround for Greeter crash
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }
    debug ("Activating {{name}} widget");
    var indicator = new {{projectname}}.Indicator ();
    return indicator;
}
