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
using Xml;

namespace Alcadica.Services { 
	public class ProjectFileService {

		public File project_file { get; set; }
		public weak Doc project_xml { get; set; }
		public Entities.Project.Project project { get; set; }
		
		public ProjectFileService () {
			Xml.Parser.init ();
		}

		public static ProjectFileService open (string filepath) {
			ProjectFileService instance = new ProjectFileService ();

			if (instance.read (filepath)) {
				instance.parse ();
			}

			return instance;
		}

		protected unowned Xml.Node* get_node_by_name (Xml.Node* nodes, string name) {
			Xml.Node* node = null;

			for (Xml.Node* iter = nodes->children; iter != null; iter = iter->next) {
				if (iter->type == Xml.ElementType.ELEMENT_NODE && iter->name == name) {
					node = iter;
					break;
				}
			}

			return node;
		}

		protected string? get_node_content_by_name (Xml.Node* nodes, string name) {
			Xml.Node* node = get_node_by_name (nodes, name);

			if (node == null) {
				return "";
			}

			return node->get_content ();
		}

		protected unowned Xml.Node* get_project_data (Xml.Node* nodes) {
			return get_node_by_name (nodes, "data");
		}

		protected Entities.Project.ProjectVersion get_project_version (Xml.Node* nodes) {
			Entities.Project.ProjectVersion entity = new Entities.Project.ProjectVersion ();
			
			Xml.Node* versionnodes = get_node_by_name (nodes, "version");

			for (Xml.Node* iter = versionnodes->children; iter != null; iter = iter->next) {
				switch (iter->name) {
					case "major": 
						entity.major = int.parse (iter->get_content ());
					break;
					case "minor": 
						entity.minor = int.parse (iter->get_content ());
					break;
					case "patch": 
						entity.patch = int.parse (iter->get_content ());
					break;
				}
			}

			return entity;
		}

		protected List<Entities.Project.ProjectItemSource> get_source_list (Xml.Node* nodes) {
			List<Entities.Project.ProjectItemSource> list = new List<Entities.Project.ProjectItemSource> ();
			Xml.Node* sourcenodes = this.get_node_by_name (nodes, "sources");

			if (sourcenodes == null) {
				return list;
			}

			for (Xml.Node* iter = sourcenodes->children; iter != null; iter = iter->next) {
				if (iter->type == Xml.ElementType.ELEMENT_NODE && iter->name == "source") {
					var entity = new Entities.Project.ProjectItemSource ();

					string? property_value = iter->get_prop (entity.nodename);
					
					if (property_value != null) {
						entity.filename = iter->get_prop (entity.nodename);
						list.append (entity);
					}
				}
			}

			return list;
		}

		protected bool parse () {
			if (this.project_xml == null) {
				return false;
			}

			Xml.Node* rootnode = this.project_xml.get_root_element ();

			if (rootnode == null) {
				warning ("Not found");
				return false;
			}

			if (rootnode->child_element_count () == 0) {
				return false;
			}
			
			this.project = new Entities.Project.Project ();
			
			string? name = this.get_node_content_by_name (rootnode, "name");
			string? rdnn = this.get_node_content_by_name (rootnode, "rdnn");
			
			this.get_project_data (rootnode);

			if (name != "" && name != null) {
				this.project.project_name = name;
			}

			if (rdnn != "" && rdnn != null) {
				this.project.rdnn = rdnn;
			}

			this.project.sources = this.get_source_list (rootnode);
			this.project.version = this.get_project_version (rootnode);

			return true;
		}

		protected bool read (string filepath) {
			this.project_file = File.new_for_path (filepath);
			
			if (this.project_file.query_exists ()) {
				this.project_xml = Xml.Parser.parse_file (filepath);
				return true;
			}

			return false;
		}

		public void close () {
			Xml.Parser.cleanup ();
		}

		public void refresh () {
			ProjectFileService.open (this.project_file.get_path ());
		}
	}
}