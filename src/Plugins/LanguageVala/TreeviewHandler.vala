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

using Alcadica.Develop.Plugins;
using Alcadica.Develop.Plugins.Entities.Editor;

namespace com.alcadica.develop.plugins.LanguageVala { 
    public class TreeviewHandlers : Object {
        public static Entities.PluginContext plugin_context { get; set; }
        public static string domain = LanguageValaPlugin.PluginDomain;

        public static void handle_menu_folder_right_click (Entities.Editor.TreeviewMenuContext context) {
            if (!context.is_domain_acceptable (LanguageValaPlugin.PluginDomain)) {
				return;
            }
            
            context.add_item (_("Add folder")).activate.connect (() => { 
				plugin_context.editor.treeview.request_add_new_directory (context);
			});
            
            context.add_item (_("Add existing folder")).activate.connect (() => { 
				plugin_context.editor.treeview.request_add_new_directory (context);
			});
            
            context.add_item (_("Add existing file")).activate.connect (() => { 
				plugin_context.editor.treeview.request_add_new_file (context);
			});
        }
    }
}