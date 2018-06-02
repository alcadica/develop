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
using Alcadica.LibValaProject.Entities;

namespace Alcadica.LibValaProject.Services {
	public class ProjectSourceNode {
	
		private static ProjectItem get_instance (string chunk) {
			ProjectItem data;
				
			if (chunk.index_of (".vala") > 0) {
				data = new ProjectItemSource ();
			} else {
				data = new ProjectItemDirectory ();
			}

			data.filename = chunk;

			return data;
		}
		
		private static string[] get_chunks (string path) {
			return path.split(Path.DIR_SEPARATOR.to_string ());
		}

		public static ProjectItem? build_from_filepath (string path) {
			ProjectItem? previous = null;
			ProjectItem? node = null;
			string[] chunks = get_chunks (path);

			if (chunks.length == 0) {
				return node;
			}

			foreach (var chunk in chunks) {
				ProjectItem data = get_instance (chunk);
				
				if (previous == null) {
					previous = data;
					continue;
				} else {
					previous.append (data);
				}
			}

			return node;
		}

		public static ProjectItem build_from_files_list (List<string> list) {
			ProjectItemDirectory root = new ProjectItemDirectory ();

			foreach (string item in list) {
				string[] chunks = get_chunks (item);

				if (chunks.length == 0) {
					continue;
				}

				string current_path = "";
				ProjectItem current_node = root;
				
				foreach (string chunk in chunks) {
					ProjectItem data = get_instance (chunk);
					current_path = Path.build_filename (current_path, chunk);

					data.nodepath = current_path;

					if (current_node.has_child (data.nodepath)) {
						current_node = current_node.get_child_by_pathname (data.nodepath);
						continue;
					} else {
						print ("\n [append] " + data.nodepath + " on [current] " + current_node.nodepath);
						current_node.append (data);
						current_node = data;
						continue;
					}
				}
			}

			return root;
		}
	}
}