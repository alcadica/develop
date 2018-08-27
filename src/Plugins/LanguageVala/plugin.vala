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

[ModuleInit]
public static Type plugin_init (GLib.TypeModule type_module) {
	return typeof (com.alcadica.develop.plugins.LanguageVala.LanguageValaPlugin);
}

namespace com.alcadica.develop.plugins.LanguageVala {
	public class LanguageValaPlugin : Plugin {
		public override string get_name () {
			return "com.alcadica.develop.plugins.LanguageVala.LanguageValaPlugin";
		}
		
		public override void activate (Entities.PluginContext context) {
			context.project.parsers.append (new entities.ValaProjectParser ());
		}

		public override void deactivate (Entities.PluginContext context) {
			
		}
		
		public override void registered () {
			welcome_log_message ("Let's make Vala great again");
		}

		public override void unregistered () {
			this.dispose ();
		}
	}
}