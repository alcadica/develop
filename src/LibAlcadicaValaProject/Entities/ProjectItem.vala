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
namespace Alcadica.LibValaProject.Entities {
	public const string NODE_DIRECTORY = "directory"; 
	public const string NODE_FILE = "file"; 
	
	public abstract class ProjectItem {
		protected string _filename { get; set; }
		public List<ProjectItem> children = new List<ProjectItem> ();
		public ProjectItem? parent = null;
		public string friendlyname { get; set; }
		public string nodename { get; set; }
		public string nodepath { get; set; }

		public bool has_children {
			get {
				return this.children.length () > 0;
			}
		}

		public bool is_leaf {
			get {
				return this.children.length () == 0 && this.parent != null;
			}
		}

		public bool is_tree {
			get {
				return this.children.length () > 0;
			}
		}

		public ProjectItem root {
			get {
				weak ProjectItem current = this;

				while (current.parent != null) {
					current = current.parent;
				}

				return current;
			}
		}

		public string filename { 
			get {
				return this._filename;
			}
			set {
				this.friendlyname = this.get_friendly_name (value);
				this._filename = value;
			}
		}

		public uint length {
			get {
				return this.children.length ();
			}
		}

		protected abstract string get_friendly_name (string value);

		public void append (ProjectItem item) {
			item.parent = this;
			this.children.append (item);
		}

		public ProjectItem? get_child (int index) {
			if (index > this.length) {
				return null;
			}
			
			return this.children.nth_data (index);
		}

		public bool has_child (string path) {
			return this.get_child_by_pathname (path) != null;
		}
		
		public ProjectItem? get_child_by_pathname (string path) {
			ProjectItem? item = null;

			for (int i = 0; i < children.length (); i++) {
				if (children.nth_data (i).nodepath == path) {
					item = children.nth_data (i);
					break;
				}
			}

			return item;
		}

		public List<ProjectItem> get_flatterned_children () {
			List<ProjectItem> result = new List<ProjectItem> ();

			if (this.children.length () == 0) {
				return result;
			}

			result = this.children.copy ();

			for (int i = 0; i < result.length (); i++) {
				result.concat (result.nth_data (i).get_flatterned_children ());	
			}


			return result;
		}
	}
}