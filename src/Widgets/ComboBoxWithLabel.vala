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
using Alcadica.Widgets;
using Granite;
using Gtk;

namespace Alcadica.Widgets { 
	public class ComboBoxWithLabelOption : Entities.Generic.KeyValuePair<int, string> {
		public ComboBoxWithLabelOption (int key, string label) {
			Object(key: key, value: label);
		}
	}
	
	public class ComboBoxWithLabel : Gtk.Grid {
		public ComboBoxText combobox { get; set; }
		public Gtk.Label label { get; set; }
		public List<ComboBoxWithLabelOption> options = new List<ComboBoxWithLabelOption> ();
		public signal void changed(int key);

		public int value {
			get {
				int index = this.combobox.get_active ();
				return this.options.nth_data(index).key;
			}
			set {
				foreach (var item in this.options) {
					if (item.key == value) {
						this.combobox.set_active (this.options.index (item));
					}
				}
			}
		}

		public ComboBoxWithLabel (string entry_label) {
			this.combobox = new ComboBoxText ();
			this.label = new Label (entry_label);
			this.label.set_xalign (0);
			this.label.get_style_context ().add_class (Granite.STYLE_CLASS_PRIMARY_LABEL);
			this.orientation = Gtk.Orientation.VERTICAL;
			this.row_spacing = 0;

			this.add (this.label);
			this.add (this.combobox);
			this.set_hexpand (true);

			this.label.margin_bottom = 4;

			this.combobox.changed.connect (() => {
				this.changed (this.value);
			});
		}

		public void add_option (int key, string option_label) {
			ComboBoxWithLabelOption option = new ComboBoxWithLabelOption(key, option_label);
			this.options.append (option);
			this.combobox.append_text (option.value);
		}

		public ComboBoxWithLabelOption? get_option_by_value (int value) {
			ComboBoxWithLabelOption? option = null;
			
			foreach (var item in this.options) {
				if (item.key == value) {
					option = item;
				}
			}

			return option;
		}
	}
}