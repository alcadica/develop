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

namespace Alcadica.Develop.Entities.Modules { 
	public class Module : TypeModule {
		[CCode (has_target = false)]
		private delegate Type ModuleInitFunc (TypeModule module);
		private unowned Type type;
		private GLib.Module module = null;
		private string directory = null;
		private string name = null;
		private string init_symbol = null;

		public Module (string directory, string name, string init_symbol) {
			this.directory = directory;
			this.name = name;
			this.init_symbol = init_symbol;
		}

		public unowned Type get_loaded_type () {
			return this.type;
		}

		public override bool load () {
			debug (@"Loading module $name");
			
			this.module = GLib.Module.open (GLib.Module.build_path (directory, name), GLib.ModuleFlags.BIND_LAZY);
			
			if (this.module == null) {
				error (@"Module $name not found");
			} else {
				debug (@"Module $name found");
			}
		
			void* module_init_method = null;

			if (!module.symbol (this.init_symbol, out module_init_method)) {
				error (@"Symbol $init_symbol not found");
			} else {
				debug (@"Symbol $init_symbol found");
			}
			
			this.type = ((ModuleInitFunc) module_init_method) (this);
			this.use ();

			return true;
		}
		
		public override void unload () {
			this.module = null;
			debug (@"Module $name unloaded");
		}
	}
}