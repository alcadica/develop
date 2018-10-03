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

namespace com.alcadica.develop.plugins.LanguageVala.Treeview { 
    public class AssetsHandler : Object {
        protected Entities.PluginContext plugin_context { get; set; }

        public AssetsHandler (Entities.PluginContext plugin_context) {
            this.plugin_context = plugin_context;
        }
        
        public void add_assets (TreeviewMenuContext context, List<string> assets) {
            
        }

        public List<string> get_assets (TreeviewMenuContext context) {
            List<string> assets = new List<string> ();

            foreach (var asset in context.source_tree_item.get_flatterned_leaves ()) {
                assets.append (asset.node_path);
            }

            return assets;
        }

        public void manage_assets (TreeviewMenuContext context) {
            var assets = this.get_assets (context);
            var source_tree_item = context.source_tree_item;
            
            plugin_context.editor.show_assets (_("Assets"), assets, source_tree_item);
        }
        
        public void remove_assets (TreeviewMenuContext context, List<string> assets) {
            
        }
    }
}