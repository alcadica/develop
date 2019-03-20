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

namespace Alcadica.Widgets {
	public class EntryWithLabel : Gtk.Grid {
		protected bool _is_optional = false;
		public Entry entry { get; set; }
		public Gtk.Label? label_optional = null;
		public Gtk.Label label { get; set; }
		public Gtk.InputPurpose input_purpose {
			get {
				return this.entry.input_purpose;
			}
			set {
				this.entry.input_purpose = value;
			}
		}
		public signal void changed (string text);
		public bool editable {
			get {
				return this.entry.editable;
			}
			set {
				this.entry.editable = value;
			}
		}
		public bool invalid {
			get {
				return this.entry.invalid;
			}
			set {
				this.entry.invalid = value;
			}
		}
		public bool optional {
			get {
				return this._is_optional;
			}
			set {
				this._is_optional = value;

				if (this.label_optional == null) {
					this.label_optional = new Gtk.Label (_("Optional"));
					this.label_optional.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);
					this.attach_next_to (this.label_optional, this.label, Gtk.PositionType.RIGHT);
				}

				if (value) {
					this.label_optional.show ();
				} else {
					this.label_optional.hide ();
				}
			}			
		}
		public string pattern {
			get {
				return this.entry.pattern;
			}
			set {
				this.entry.pattern = value;
			}
		}
		public string text {
			get {
				return this.entry.text;
			}
			set {
				this.entry.text = value;
			}
		}
		public bool valid {
			get {
				return this.entry.valid;
			}
			set {
				this.entry.valid = value;
			}
		}
		
		public EntryWithLabel (string entry_label, string? placeholder_text = null, string? optional_label = null) {
			this.entry = new Entry ();
			this.label = new Gtk.Label (entry_label);
			
			this.label.set_xalign (0);
			this.label.get_style_context ().add_class (Granite.STYLE_CLASS_PRIMARY_LABEL);
			this.orientation = Gtk.Orientation.VERTICAL;
			this.row_spacing = 0;
			
			this.attach (this.label, 0, 0, 1);
			this.attach (this.entry, 0, 1, 2);
			this.set_expand (true);

			this.label.margin_bottom = 4;

			if (placeholder_text != null) {
				this.entry.placeholder_text = placeholder_text;
			}

			this.entry.changed.connect (() => {
				this.changed (this.entry.text);
			});
		}

		public void focusin () {
			this.entry.grab_focus ();
		}

		public void set_expand (bool expand) {
			this.hexpand = true;
			this.entry.hexpand = expand;
			this.label.hexpand = expand;
		}

		public void set_xalign (int align) {
			this.label.set_xalign (align);
		}
	}
}