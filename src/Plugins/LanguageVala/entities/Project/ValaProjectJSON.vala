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
		public ValaProjectJSONBuild build { get; set; }
		public List<ValaProjectJSONDependency> dependencies = new List<ValaProjectJSONDependency> ();
		public ValaProjectJSONFiles files { get; set; }
		public string name { get; set; }
		public ValaProjectJSONVala vala { get; set; }

		public ValaProjectJSON () {
			this.build = new ValaProjectJSONBuild ();
			this.files = new ValaProjectJSONFiles ();
			this.vala = new ValaProjectJSONVala ();
		}

		public static ValaProjectJSON from_json (string content) throws Error {
			var project = new ValaProjectJSON ();
			Json.Parser parser = new Json.Parser ();

			debug ("parsing valaproject.json");

			parser.load_from_data (content);
			
			debug ("data loaded");
			
			Json.Node node = parser.get_root ();
			Json.Object object = node.get_object ();

			if (node.get_node_type () != Json.NodeType.OBJECT) {
				throw new ProjectParserError.INVALID_FORMAT ("Unexpected element type %s", node.type_name ());
			}

			foreach (var member in object.get_members ()) {
				switch (member) {
					case "name": 
						project.name = object.get_string_member (member);
						debug ("valaproject.json project name: " + project.name);
					break;
					case "build": 
						var build = object.get_object_member ("build");
						
						project.build.build_directory =  build.get_string_member ("directory");
						project.build.build_output =  build.get_string_member ("output");
						project.build.build_system =  build.get_string_member ("system");
						project.build.build_type =  build.get_string_member ("type");

						debug ("valaproject.json build_directory: " + project.build.build_directory);
						debug ("valaproject.json build_system: " + project.build.build_system);
						debug ("valaproject.json build_type: " + project.build.build_type);
					break;
					case "dependencies": 
   						object.get_array_member ("dependencies").foreach_element ((array, index, node) => {
							ValaProjectJSONDependency instance = new ValaProjectJSONDependency ();
							var array_item = array.get_object_element (index);
							   
							instance.name = array_item.get_string_member ("name");
							instance.version = array_item.get_string_member ("version");
   							
   							project.dependencies.append (instance);
   						});
					break;
					case "files":
						var files = object.get_object_member ("files");

						files.get_array_member ("assets").foreach_element ((array, index) => {
							ValaProjectJSONFilesAsset asset = new ValaProjectJSONFilesAsset ();
							var asset_object = array.get_object_element (index);

							if (!asset_object.has_member ("file") && !asset_object.has_member ("files")) {
								throw new ProjectParserError.INVALID_FORMAT (_("Invalid asset format, missing both file and files member."));
							}

							if (asset_object.has_member ("file") && asset_object.has_member ("files")) {
								throw new ProjectParserError.INVALID_FORMAT (_("Invalid asset format, cannot have both file and files member."));
							}

							if (asset_object.has_member ("file")) {
								asset.asset_files.append (asset_object.get_string_member ("file"));
							}

							if (asset_object.has_member ("files")) {
								asset_object.get_array_member ("files").foreach_element ((array, index) => {
									string filename = array.get_string_element (index);
									asset.asset_files.append (filename);

									debug (@"valaproject.json asset: adding file " + filename);
								});
							}

							if (!asset_object.has_member ("dest") && !asset_object.has_member ("type")) {
								throw new ProjectParserError.INVALID_FORMAT ("Missing dest member on index %s", index.to_string ());
							} else if (!asset_object.has_member ("dest") && asset_object.has_member ("type")) {
								switch (asset_object.get_string_member ("type").up ()) {
									case ValaProjectJSONFilesAssetType.APP_DATA_XML:
										asset.asset_dest = "/usr/share/metainfo";
										break;
									case ValaProjectJSONFilesAssetType.DESKTOP_ENTRY:
										asset.asset_dest = "/usr/share/applications";
										break;
									case ValaProjectJSONFilesAssetType.ICONS:
										asset.asset_dest = "/usr/share/icons/hicolor";
										break;
									default:
										throw new ProjectParserError.INVALID_FORMAT ("Missing dest member on index %s", index.to_string ());
								}
							} else {
								asset.asset_dest = asset_object.get_string_member ("dest");
							}

							if (asset_object.has_member ("type")) {
								asset.asset_type = asset_object.get_string_member ("type");
							}

							project.files.assets.append (asset);
						});

						files.get_array_member ("source").foreach_element ((array, index) => {
							string filename = array.get_string_element (index);
							project.files.source.append (filename);

							debug ("valaproject.json source: adding file " + filename);
						});
					break;
					case "vala": 
						var vala = object.get_object_member ("vala");
						
						project.vala.version = vala.get_string_member ("version");
						debug ("valaproject.json vala version: " + project.vala.version);
					break;
				}
			}

			return project;
		}
	}

	public class ValaProjectJSONBuild : Object {
		public string build_directory { get; set; }
		public string build_output { get; set; }
		public string build_system { get; set; }
		public string build_type { get; set; }
	}
	
	public class ValaProjectJSONDependency : Object {
		public string name { get; set; }
		public string version { get; set; }
	}

	public class ValaProjectJSONFiles : Object {
		public List<ValaProjectJSONFilesAsset> assets = new List<ValaProjectJSONFilesAsset> ();
		public List<string> source = new List<string> ();
	}

	public class ValaProjectJSONFilesAsset : Object {
		public string asset_dest { get; set; }
		public string? asset_type { get; set; }
		public List<string> asset_files = new List<string> ();
	}

	public class ValaProjectJSONFilesAssetType : Object {
		public const string APP_DATA_XML = "APPDATA_XML";
		public const string DEB_INSTALL = "DEB_INSTALL";
		public const string DESKTOP_ENTRY = "DESKTOP_ENTRY";
		public const string DIRECTORY = "DIRECTORY";
		public const string ICONS = "ICONS";
	}
	
	public class ValaProjectJSONVala : Object {
		public string version { get; set; }
	}
}
