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
using Alcadica.Develop.Entities.Plugin;
using Alcadica.Develop.Plugins;
using GLib.Environment;

namespace Alcadica.Develop.Infrastructure { 
	public class PluginLoader {
		protected static List<string> directories = new List<string> ();
		protected static List<string> plugins = new List<string> ();
		
		protected static void list_plugins (string directory) {
			try {
				Dir dir = Dir.open (directory, 0);
				string name;

				while ((name = dir.read_name ()) != null) {
					string path = Path.build_filename (directory, name);

					if (
						FileUtils.test (path, FileTest.IS_REGULAR)
						&&
						FileUtils.test (path, FileTest.IS_EXECUTABLE)
						&&
						path.splice (0, -2) == "so"
					) {
						plugins.append (path);
					}
				}
			} catch (FileError error) {
				warning (error.message);
			}
		}

		protected static Plugin load_plugin (string pluginpath) {
			string directory = Path.get_dirname (pluginpath);
			string name = Path.get_basename (pluginpath);
			
			TypeModule module = new PluginModule (directory, name);

			module.load ();

			return (Plugin) Object.new (Type.from_name ("Plugin"));
		}

		public static void init () {
			directories = new List<string>();
			plugins = new List<string>();

			string default_directory = Path.build_filename (Path.DIR_SEPARATOR.to_string (), "usr", "share", APP_ID, "plugins");
			string home_directory = Path.build_filename (get_home_dir (), ".local", "share", APP_ID, "plugins");

			directories.append (default_directory);
			directories.append (home_directory);
		}

		public static void load_plugins () {
			foreach (var directory in directories) {
				list_plugins (directory);
			}

			foreach (var pluginpath in plugins) {
				var plugin = load_plugin (pluginpath);

				plugin.registered ();
			}
		}
	}
}