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
	return typeof (com.alcadica.develop.plugins.ElementaryTemplates);
}

namespace com.alcadica.develop.plugins {
	public class ElementaryTemplates : Plugin {
		public override string get_name () {
			return "com.alcadica.develop.plugins.ElementaryTemplates";
		}
		
		public override void activate (Entities.PluginContext context) {
			info ("Elementary Templates are activated");
		}
		
		public override void deactivate (Entities.PluginContext context) {
			info ("Elementary Templates are deactivated");
		}
		
		public override void registered () {
			info ("Elementary Templates are registered");
		}
		
		public override void unregistered () {
			info ("Elementary Templates are unregistered");
			this.dispose ();
		}
	}
}