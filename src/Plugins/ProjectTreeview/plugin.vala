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

public static Type plugin_init () {
	return typeof (com.alcadica.develop.plugins.Treeview);
}

namespace com.alcadica.develop.plugins {
	public class Treeview : Plugin {
		public override string get_name () {
			return "Treeview";
		}
		
		public override void activate (Entities.PluginContext context) {
			print ("\nhello world");
		}

		public override void deactivate (Entities.PluginContext context) {

		}
		
		public override void dispose () { }

		public override void registered () {
			print ("\nRegistered " + this.get_name ());
		}
	}
}