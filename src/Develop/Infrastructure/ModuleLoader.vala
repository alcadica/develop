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
using Alcadica.Develop.Entities.Modules;
using GLib.Environment;

namespace Alcadica.Develop.Infrastructure { 
	public abstract class ModuleLoader<T> {
		private List<string> directories = null;
		private List<string> modules = null;
		private string main_method = null;
		private string type_name = null;

		public ModuleLoader (string type_name, string main_method, string[] search_in_directories) {
			this.directories = new List<string> ();
			this.modules = new List<string> ();
			this.main_method = main_method;
			this.type_name = type_name;

			foreach (string directory in search_in_directories) {
				directories.append (directory);
			}
		}
		
		protected void list_modules (string directory) {
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
						modules.append (path);
					}
				}
			} catch (FileError error) {
				warning (error.message);
			}
		}

		protected T? load_module (string modulepath) {
			Object instance;
			string directory = Path.get_dirname (modulepath);
			string name = Path.get_basename (modulepath);
			Type? type;
			
			Alcadica.Develop.Entities.Modules.Module module = new Alcadica.Develop.Entities.Modules.Module (directory, name, this.main_method);

			if (!module.load ()) {
				return null;
			}

			type = module.get_loaded_type ();

			if (type == null) {
				return null;
			}
			
			instance = Object.new (type);

			return (T) instance;
		}

		protected abstract void on_module_loaded (T instance);

		public void load_modules () {
			foreach (var directory in directories) {
				list_modules (directory);
			}

			foreach (var modulepath in modules) {
				var module = load_module (modulepath);

				on_module_loaded (module);
			}
		}
	}
}