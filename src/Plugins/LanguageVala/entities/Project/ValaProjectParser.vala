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
using Alcadica.Develop.Plugins.Entities.Project;

namespace com.alcadica.develop.plugins.LanguageVala.entities { 
	public class ValaProjectParser : ProjectParser {
		public override string parser_name {
			get {
				return "valaproject";
			}
		}
		
		public override string project_file_name {
			get {
				return "valaproject.json";
			}
		}

		public override Project parse (string filename, string project_file_content) throws Error {
			ValaProjectJSON project_json = ValaProjectJSON.from_json (project_file_content);
			string root_dir = Path.get_dirname (filename);

			Project project = new Project (project_json.name, filename);

			project.file_system.root_dir = root_dir;

			foreach (string file in project_json.files.source) {
				if (!project.file_system.has_file (file)) {
					project.file_system.add (file);
				}
			}

			project.tree.root_string_path = root_dir;
			project.tree.root.node_name = project.project_name;

			foreach (string file in project.file_system.files) {
				project.tree.add_path (file);
			}

			return project;
		}
	}
}