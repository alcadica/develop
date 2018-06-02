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
namespace Alcadica.LibValaProject.Entities {
	public class ProjectItemSource : ProjectItem {
		public ProjectItemSource () {
			this.nodename = NODE_FILE;
		}

		protected override string get_friendly_name (string value) {
			if (value == null || value == "") {
				return value;
			}
			
			return Path.get_basename (value).replace (".vala", "").to_string ();
		}

		public string[] get_dirs () {
			return Path.get_dirname (this.filename).split (Path.DIR_SEPARATOR.to_string ());
		}
	}
} 