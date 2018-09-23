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
using Gtk;

namespace Alcadica.Develop.Widgets.Dialogs {
    public enum ConfirmRemoveButtonKey {
        Undo,
        Confirm
    }
    
	public class ConfirmRemove : Granite.MessageDialog {
        public signal void on_confirm ();
        
        public ConfirmRemove (string primary_text, string secondary_text) {
            Object(
                primary_text: primary_text,
                secondary_text: secondary_text,
                image_icon: null
            );
        }

        construct {
            add_button (_("undo"), ConfirmRemoveButtonKey.Undo);
            var confirm_button = add_button (_("confirm"), ConfirmRemoveButtonKey.Confirm);
            set_default_response (ConfirmRemoveButtonKey.Undo);

            confirm_button.get_style_context ().add_class ("destructive-action");

            try {
                image_icon = Icon.new_for_string ("dialog-warning");
            } catch (Error error) {
                warning (error.message);
            }

            response.connect (key => {
                if (key == ConfirmRemoveButtonKey.Confirm) {
                    on_confirm ();
                }
                
                close ();
            });
        }
	}
}