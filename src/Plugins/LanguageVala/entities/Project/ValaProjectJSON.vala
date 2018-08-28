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
	public class ValaProjectJSON : Object {
		public string name { get; set; }
		public List<ValaProjectJSONDependency> dependencies = new List<ValaProjectJSONDependency> ();
		public ValaProjectJSONBuild build { get; set; }
		public ValaProjectJSONVala vala { get; set; }

		public ValaProjectJSON () {
			this.build = new ValaProjectJSONBuild ();
			this.vala = new ValaProjectJSONVala ();
		}

		public static ValaProjectJSON from_json (string content) throws Error {
			var project = new ValaProjectJSON ();
			Json.Parser parser = new Json.Parser ();
			Json.Node node = parser.get_root ();
			Json.Object object = node.get_object ();

			if (node.get_node_type () != Json.NodeType.OBJECT) {
				throw new ProjectParserError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
			}

			foreach (var member in object.get_members ()) {
				switch (member) {
					case "name": 
						project.name = object.get_string_member (member);
					break;
					case "build": 
						var build = object.get_object_member ("build");
						
						project.build.build_directory =  build.get_string_member ("build_directory");
						project.build.build_system =  build.get_string_member ("build_system");
						project.build.build_type =  build.get_string_member ("build_type");
					break;
					case "dependencies": 
   						object.get_array_member ("dependencies").foreach_element ((array, index, node) => {
   							ValaProjectJSONDependency instance = new ValaProjectJSONDependency ();
   							
   							project.dependencies.append (instance);
   						});
					break;
					case "vala": 
						var vala = object.get_object_member ("vala");
						
						project.vala.version = vala.get_string_member ("version");
					break;
				}
			}

			return project;
		}
	}

	public class ValaProjectJSONBuild : Object {
		public string build_directory { get; set; }
		public string build_system { get; set; }
		public string build_type { get; set; }
	}
	
	public class ValaProjectJSONDependency : Object {
		public string name { get; set; }
		public string version { get; set; }
	}

	public class ValaProjectJSONVala : Object {
		public string version { get; set; }
	}
}
