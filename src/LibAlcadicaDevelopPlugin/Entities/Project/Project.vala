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
	public class Project : Object {
		public ProjectFileSystem file_system = new ProjectFileSystem ();
		public ProjectSettings settings = new ProjectSettings ();
		public string project_file { get; set; }
		public string project_name { get; set; }
		public signal void file_did_add (string filename);
		public signal void file_did_remove (string filename);
		public signal void request_add_file (string filename);
		public signal void request_project_is_closing ();
		public signal void request_remove_file (string filename);

		public Project (string? name) {
			this.project_name = name;
		}

		public void parse () { }
	}
}