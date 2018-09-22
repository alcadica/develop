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
using Alcadica.Develop.Services.Editor;
using Alcadica.Develop.Plugins.Entities.Common;

namespace Alcadica.Develop.Widgets.Editor {
    public class Assets : Box {
        private ListBox list_box;
        
        construct {
            var plugin_context = Services.Editor.PluginContext.context;
            var scrolled_window = new Gtk.ScrolledWindow (null, null);

            this.list_box = new ListBox ();
            this.add (new Granite.HeaderLabel (_("Assets")));

            scrolled_window.add (this.list_box);

            orientation = Orientation.VERTICAL;

            this.pack_start (scrolled_window);

            plugin_context.editor.show_assets.connect (show_assets);
        }

        private ListBoxRow create_asset_row (string label) {
            ListBoxRow element = new ListBoxRow ();
            CheckButton element_selectable = new CheckButton.with_label (label);

            element.activatable = true;
            element.selectable = true;
            element.add (element_selectable);

            return element;
        }

        private void empty_assets () {
            foreach (var child in list_box.get_children ()) {
                child.dispose ();
            }   
        }

        private void show_assets (string assets_title, List<string> assets) {
            empty_assets ();
            
            foreach (var asset in assets) {
                var element = this.create_asset_row (asset);
                
                list_box.add (element);
            }

            list_box.show_all ();
        }
    }
}