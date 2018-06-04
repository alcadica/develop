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

namespace Alcadica.Develop.Providers {
	public class ProviderRegistry : Object {

		protected static List<ProviderBase> providers = new List<ProviderBase> ();

		public static void activate (ProviderBase provider) {
			provider.activate ();
		}

		public static ProviderBase? get_provider (string provider_name) {
			ProviderBase? provider = null;
			
			for (int a = 0; a < providers.length (); a++) {
				if (providers.nth_data (a).get_name () == provider_name) {
					provider = providers.nth_data (a);
					break;
				}
			}

			return provider;
		}

		public static bool is_registered (string provider_name) {
			return get_provider (provider_name) != null;
		}

		public static void deactivate (ProviderBase provider) {
			provider.deactivate ();
		}
		
		public static void register (ProviderBase provider) {
			if (!is_registered (provider.get_name ())) {
				providers.append (provider);
			}
		}

		public static void register_providers () {
			Type type = typeof (ProviderBase);

			foreach (Type child_type in type.children ()) {
				info ("[ProviderRegistry]");
				var provider = Infrastructure.invoke <ProviderBase>(child_type.name ());
				register (provider);
			}
		}
	}
}