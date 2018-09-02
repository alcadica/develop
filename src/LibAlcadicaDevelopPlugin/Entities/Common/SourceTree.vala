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

namespace Alcadica.Develop.Plugins.Entities.Common {
	public class SourceTree : Object {
		protected string _domain { get; set; }
		public SourceTreeItem root { get; private set; }
		public string domain {
			get {
				return _domain;
			}
			set {
				_domain = value;

				debug (@"Setting domain to $_domain");
				
				foreach (var child in this.root.get_flatterned_children ()) {
					if (child != null) {
						child.domain = _domain;
					}
				}
			}
		}
		public string root_string_path { get; set; }
		public signal void item_did_add (SourceTreeItem item);
		public signal void item_did_remove (SourceTreeItem item);
		public signal void tree_did_change ();

		public SourceTree () {
			this.root = new SourceTreeItem ();
			this.root.tree = this;

			this.item_did_add.connect (() => { this.tree_did_change (); });
			this.item_did_remove.connect (() => { this.tree_did_change (); });
		}

		public SourceTreeItem create_item (string node_name) {
			SourceTreeItem item = new SourceTreeItem ();

			item.node_name = node_name;

			return item;
		}
	}
}