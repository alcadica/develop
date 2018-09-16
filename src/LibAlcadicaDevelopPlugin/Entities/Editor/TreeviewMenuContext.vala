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

namespace Alcadica.Develop.Plugins.Entities.Editor {
	protected class TreeviewMenuItemContext {
		public List<TreeviewMenuItemContext> children = new List<TreeviewMenuItemContext> ();
		public string label { get; set; }
		public signal void activate (Common.SourceTreeItem? item = null);
	}

	public enum TreeviewMenuContextType {
		Custom,
		Directory,
		File,
		Symbol
	}
	
	public class TreeviewMenuContext {

		public bool has_domain {
			get {
				return domain != "";
			}
		}

		public unowned string domain { get; set; }
		public unowned Plugins.Entities.Common.SourceTreeItem source_tree_item { get; set; }
		
		public File file { get; set; }
		
		public List<TreeviewMenuItemContext> items = new List<TreeviewMenuItemContext> ();
		
		public TreeviewMenuContextType item_type { get; set; }

		public TreeviewMenuItemContext add_item (string label) {
			info (@"TreeviewMenuContext.add_item $label");
			
			TreeviewMenuItemContext entity = new TreeviewMenuItemContext ();
			entity.label = label;

			items.append (entity);
			
			return entity;
		}

		public bool is_domain_acceptable (string querying_domain) {
			return domain == querying_domain;
		}
	}
}