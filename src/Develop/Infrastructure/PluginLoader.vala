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
using GLib.Environment;

namespace Alcadica.Develop.Infrastructure { 
	public class PluginLoader : ModuleLoader<Plugin> {

		public PluginLoader () {
			base (
				typeof (Plugin).name (), 
				"plugin_init", 
				new string[] {
					Path.build_filename (Path.DIR_SEPARATOR.to_string (), "usr", "share", APP_ID, "plugins"),
					Path.build_filename (get_home_dir (), ".local", "share", APP_ID, "plugins")
				}
			);
		}

		protected override void on_module_loaded (Plugin instance) {
			string name = instance.get_name ();
			info (@"Registering plugin $name");
			instance.registered ();
			instance.activate (Alcadica.Develop.Services.Editor.PluginContext.context);
		}
	}
}