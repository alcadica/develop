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

namespace Alcadica.Develop.Plugins.Entities {
	public class ProjectContext : Object {
		public List<Project.Project> open_projects = new List<Project.Project> ();
		public signal void project_did_close ();
		public signal void project_did_created (Project.Project project);
		public signal void project_did_open (Project.Project project);
		public signal void project_is_creating (Project.Project project);

		public Project.Project create (string project_file) {
			Project.Project project = new Project.Project (project_file);

			this.project_is_creating (project);

			return project;
		}

		public void close_all () {
			foreach (var project in this.open_projects) {
				this.close_project (project);
			}
		}

		public void close_project (Project.Project project) {
			project.request_project_is_closing ();
			open_projects.remove (project);
			this.project_did_close ();
			project.dispose ();
		}

		public bool is_open (string project_file) {
			bool result = false;

			for (int i = 0; i < this.open_projects.length (); i++) {
				if (this.open_projects.nth_data (i).project_file == project_file) {
					result = true;
					break;
				}				
			}
			
			return result;
		}
		
		public void open_project (string project_file) {
			if (this.is_open (project_file)) {
				return;
			}

			Project.Project project = new Project.Project (project_file);
			project.parse ();
			this.open_projects.append (project);
			this.project_did_open (project);
		}
	}
}