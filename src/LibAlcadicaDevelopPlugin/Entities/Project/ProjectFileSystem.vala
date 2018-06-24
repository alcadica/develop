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

namespace Alcadica.Develop.Plugins.Entities.Project {
	public class ProjectFileSystem : Object {
		public List<string> files = new List<string> ();
		public string root_dir { get; set; }
		public signal void on_add (string filename);
		public signal void on_remove (string filename);

		public uint add (string filename) {
			if (this.has_file (filename)) {
				return this.files.length ();
			}

			this.files.append (filename);
			this.on_add (filename);
			return this.files.length ();
		}

		public bool has_file (string filename) {
			bool result = false;

			for (int i = 0; i < this.files.length (); i++) {
				if (this.files.nth_data (i) == filename) {
					result = true;
					break;
				}
			}
			
			return result;
		}

		public uint remove (string filename) {
			if (!this.has_file (filename)) {
				return this.files.length ();
			}

			this.files.remove (filename);
			this.on_remove (filename);

			return this.files.length ();
		}
	}
}