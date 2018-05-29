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

namespace Alcadica.Views { 
  public class WelcomeView : Granite.Widgets.Welcome { 

    public signal void app ();
    public signal void switchboard ();
    public signal void wingpanel ();

    public WelcomeView () {
        Object (
            title: _("Develop for elementary"),
            subtitle: _("Choose what you wish to develop")
        );
    }

    construct {
        append ("distributor-logo", _("App"), _("Create a new elementary OS application."));
        append ("preferences-desktop", _("Switchboard plug"), _("Create a new elementary OS switchboard plug."));
        append ("preferences-desktop-wallpaper", _("Wingpanel indicator"), _("Create a new elementary OS wingpanel indicator."));

        this.activated.connect (index => {
            switch (index) {
                case 0: this.app (); break;
                case 1: this.switchboard (); break;
                case 2: this.wingpanel (); break;
            }
        });
    }
  }
}