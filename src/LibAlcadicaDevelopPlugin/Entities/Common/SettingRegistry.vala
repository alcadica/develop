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

namespace Alcadica.Develop.Plugins.Entities.Common {
	public class SettingRegistry {
		public List<SettingEntry> settings = new List<SettingEntry> ();

		public SettingEntry create<TValue> (string name, TValue value) {
			return new SettingEntry<TValue> (name, value);
		}

		public SettingEntry<TValue>? get_setting <TValue> (string name) {
			SettingEntry? entry = null;
			string _name = name.down ();

			for (int i = 0; i < settings.length (); i++) {
				if (settings.nth_data (i).key == _name) {
					entry = settings.nth_data (i);
					break;
				}
			}

			return entry;
		}

		public void update_entry <TValue>(string name, TValue value) {
			SettingEntry? entry = get_setting<TValue> (name);

			if (entry == null) {
				entry = create<TValue> (name, value);
				return;
			}
			
			//  entry.set_value (value);
		}
	}
}