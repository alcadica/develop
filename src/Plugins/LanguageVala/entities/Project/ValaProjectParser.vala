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
			debug (@"Parsing $filename");
			
			ValaProjectJSON project_json = ValaProjectJSON.from_json (project_file_content);

			debug (@"Project parsed");
			
			string root_dir = Path.get_dirname (filename);

			debug ("Instancing project " + project_json.name);

			Project project = new Project (project_json.name, filename);

			debug ("Done");
			debug (@"Setting project.file_system.root_dir to $root_dir");

			project.file_system.root_dir = root_dir;

			debug ("Setting project source files (" + project_json.files.source.length ().to_string () + " files)");

			foreach (string file in project_json.files.source) {
				if (!project.file_system.has_file (file)) {
					project.file_system.add (file);
				}
			}

			debug (@"Setting project.tree.root_string_path to $root_dir");
			
			project.tree.root_string_path = root_dir;
			
			debug ("Setting project.tree.root.node_name to " + project.project_name);

			project.tree.root.node_name = project.project_name;
			
			debug ("Creating dependencies tree");
			
			var dependencies_tree = project.tree.create_item (_("Dependencies"));

			project.tree.root.append_child (dependencies_tree);

			foreach (var dependency in project_json.dependencies) {
				project.tree.add_path (dependency.name + " " + dependency.version, dependencies_tree);
			}

			var sources_tree = project.tree.create_item (_ ("Sources"));

			project.tree.root.append_child (sources_tree);
			
			debug ("Setting project.tree path items (" + project.file_system.files.length ().to_string () + " items)");
			
			foreach (string file in project.file_system.files) {
				if (!project.tree.add_path (file, sources_tree)) {
					warning (@"Cannot add file $file");
				}
			}

			project.tree.domain = LanguageValaPlugin.PluginDomain;

			debug ("Done, returning instance");

			return project;
		}
	}
}