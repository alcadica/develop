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
    public enum EditableValuePromptKey {
        Undo,
        Confirm
    }
    
	public class EditableValuePrompt : Dialog {
        public signal void on_confirm ();
        public string value { get; set; }
        
        public EditableValuePrompt (string value) {
            Object(
                value: value
            );
        }

        construct {
            add_button (_("undo"), ConfirmRemoveButtonKey.Undo);
            var confirm_button = add_button (_("confirm"), ConfirmRemoveButtonKey.Confirm);
            Box box = new Box (Orientation.HORIZONTAL, 0);
            var field = new Alcadica.Widgets.EntryWithLabel (_("qweqew"));

            box.add (field);

            this.get_content_area ().pack_start (box);
            
            set_default_response (ConfirmRemoveButtonKey.Undo);

            confirm_button.get_style_context ().add_class ("primary-action");

            response.connect (key => {
                if (key == ConfirmRemoveButtonKey.Confirm) {
                    on_confirm ();
                }
                
                close ();
            });
        }
	}
}