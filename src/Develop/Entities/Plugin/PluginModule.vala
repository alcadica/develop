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

namespace Alcadica.Develop.Entities.Plugin { 
	public class PluginModule : TypeModule {
		[CCode (has_target = false)]
		private delegate Type PluginInitFunc (TypeModule module);
		private GLib.Module module = null;
		private string directory = null;
		private string name = null;

		public PluginModule (string directory, string name) {
			this.directory = directory;
			this.name = name;
		}

		public override bool load () {
			this.module = Module.open (Module.build_path (directory, name), GLib.ModuleFlags.BIND_LAZY);
			
			if (this.module == null) {
				error (@"Plugin $name not found");
			}
		
			void* plugin_init = null;

			if (!module.symbol ("plugin_init", out plugin_init)) {
				error ("No such symbol");
			}
			
			((PluginInitFunc) plugin_init) (this);
			
			return true;
		}
		
		public override void unload () {
			this.module = null;
			message (@"Plugin $name unloaded");
		}
	}
}