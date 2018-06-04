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

namespace Alcadica.Develop.Providers {
	public class PluginProvider : ProviderBase {
		protected List<Plugin> plugins = new List<Plugin> ();

		protected async void activate_plugin (Plugin plugin) {
			Alcadica.Develop.Plugins.Entities.PluginContext context = new Alcadica.Develop.Plugins.Entities.PluginContext ();
			
			plugin.activate(context);
		}

		protected async void deactivate_plugin (Plugin plugin) {
			Alcadica.Develop.Plugins.Entities.PluginContext context = new Alcadica.Develop.Plugins.Entities.PluginContext ();
			
			plugin.deactivate(context);
		}

		protected async void dispose_plugin (Plugin plugin) {
			plugin.dispose ();
		}
		
		public override string get_name () {
			return "PluginProvider";
		}

		public override void activate () {
			this.reload_plugins_list ();
			
			for (int index = 0; index < this.plugins.length (); index++) {
				var plugin = this.plugins.nth_data (index);
				this.activate_plugin.begin (plugin);
			}
		}

		public override void deactivate () {
			for (int index = 0; index < this.plugins.length (); index++) {
				var plugin = this.plugins.nth_data (index);
				this.deactivate_plugin.begin (plugin);
			}
		}

		public void reload_plugins_list () {
			this.plugins = new List<Plugin> ();
			Type type = typeof (Plugin);

			foreach (var child_plugin in type.children ()) {
				var plugin = Infrastructure.invoke<Plugin> (child_plugin.name ());

				this.plugins.append (plugin);
			}
		}

		public Plugin? get_plugin (string name) {
			Plugin? plugin = null;

			for (int index = 0; index < this.plugins.length (); index++) {
				if (this.plugins.nth_data (index).get_name () == name) {
					plugin = this.plugins.nth_data (index);
					break;
				}
			}

			return plugin;
		}
	}
}