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

		protected void set_dependencies (ValaProject project, ValaProjectJSON project_json) {
			debug ("Creating dependencies tree");
			
			var dependencies_tree = project.tree.create_item (_("Dependencies"));

			dependencies_tree.node_attributes.append (ValaProjectTreeAttributes.TYPE_DEPENDENCY);

			project.tree.root.append_child (dependencies_tree);

			foreach (var dependency in project_json.dependencies) {
				project.tree.add_path (dependency.name + " " + dependency.version, dependencies_tree);
			}

			foreach (var child in dependencies_tree.get_flatterned_children ()) {
				child.node_attributes.append (ValaProjectTreeAttributes.TYPE_DEPENDENCY);
			}
		}

		protected void set_source_files (ValaProject project, ValaProjectJSON project_json) {

			debug ("Setting project source files (" + project_json.files.source.length ().to_string () + " files)");

			foreach (string file in project_json.files.source) {
				if (!project.file_system.has_file (file)) {
					project.file_system.add (file);
				}
			}
		}

		public override Project parse (string filename, string project_file_content) throws Error {
			debug (@"Parsing $filename");
			
			ValaProjectJSON project_json = ValaProjectJSON.from_json (project_file_content);

			debug (@"Project parsed");
			
			string root_dir = Path.get_dirname (filename);

			debug ("Instancing ValaProject " + project_json.name);

			ValaProject project = new ValaProject (project_json.name, filename);

			debug ("Done");
			debug (@"Setting project.file_system.root_dir to $root_dir");

			project.file_system.root_dir = root_dir;

			this.set_source_files (project, project_json);

			debug (@"Setting project.tree.root_string_path to $root_dir");
			
			project.tree.root_string_path = root_dir;
			
			debug ("Setting project.tree.root.node_name to " + project.project_name);

			project.tree.root.node_name = project.project_name;
			
			this.set_dependencies (project, project_json);

			debug ("Creating assets tree");

			var assets_tree = project.tree.create_item (_("Assets"));

			assets_tree.node_attributes.append (ValaProjectTreeAttributes.TYPE_ASSET);

			project.tree.root.append_child (assets_tree);

			foreach (var asset in project_json.files.assets) {
				foreach (var asset_item in asset.asset_files) {
					string destpath = Path.build_filename (asset.asset_dest, asset_item);

					project.tree.add_path (destpath, assets_tree);
				}
			}

			foreach (var child in assets_tree.get_flatterned_children ()) {
				child.node_attributes.append (ValaProjectTreeAttributes.TYPE_ASSET);
			}

			var sources_tree = project.tree.create_item (_("Sources"));

			sources_tree.node_attributes.append (ValaProjectTreeAttributes.TYPE_SOURCE);

			project.tree.root.append_child (sources_tree);
			
			debug ("Setting project.tree path items (" + project.file_system.files.length ().to_string () + " items)");
			
			foreach (string file in project.file_system.files) {
				if (!project.tree.add_path (file, sources_tree)) {
					warning (@"Cannot add file $file");
				}
			}

			foreach (var child in sources_tree.get_flatterned_children ()) {
				child.node_attributes.append (ValaProjectTreeAttributes.TYPE_SOURCE);
			}

			project.tree.domain = LanguageValaPlugin.PluginDomain;

			debug ("Done, returning instance");

			return project;
		}
	}
}