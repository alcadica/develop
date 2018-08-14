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
	public interface IEntryWidget<T> : Gtk.Grid { 
		public signal void changed(T value);
		public signal void validity_state_did_change (bool state);
	}
	
	public class Entry : Gtk.Entry { 

		private bool _hide_icon = false;
		
		private bool _validity = true;
		
		public bool has_maxlength {
			get {
				return this.max_length.to_string () != "000000000000000";
			}
		}
		public bool has_minlength {
			get {
				return this.min_length.to_string () != "000000000000000";
			}
		}
		public bool has_pattern {
			get {
				return this.pattern != "" && this.pattern != null;
			}
		}
		public bool hide_icon {
			get {
				return this._hide_icon;
			}
			set {
				this._hide_icon = value;
				this.assign_icon();
			}
		}
		public bool invalid { 
			get {
				return !this._validity;
			} 
			set {
				if (value != this._validity) {
					this.on_validity_change ();
				}
				
				this._validity = !value;
				this.assign_icon ();
			} 
		}
		public int min_length { get; set; }
		public bool valid {
			get {
				return this._validity;
			}
			set {
				if (value != this._validity) {
					this.on_validity_change ();
				}
				
				this._validity = value;
				this.assign_icon ();
			}
		}
		public bool should_validate {
			get {
				return this.has_pattern || this.has_maxlength || this.has_minlength;
			}
		}
		public signal void on_invalid ();
		public signal void on_valid ();
		public signal void on_validity_change ();
		public string pattern { get; set; }

		construct {
			this.changed.connect (() => {
				this.validate ();
				if (this.valid) {
					this.on_valid ();
				} else {
					this.on_invalid ();
				}
			});
			
			this.on_valid.connect (() => {
				this.assign_icon ();
			});

			this.on_invalid.connect (() => {
				this.assign_icon ();
			});
		}

		private void assign_icon () {
			if (this._hide_icon) {
				return;
			}
			
			if (!this.should_validate) {
				return;
			}
			
			if (this.valid) {
				this.secondary_icon_name = "selection-checked";
			} else {
				this.secondary_icon_name = "";
			}
		}

		public void validate () {
			if (!this.should_validate) {
				this.valid = true;
				return;
			}
			
			string _pattern = this.pattern;

			if (!this.has_pattern) {
				_pattern = ".";
			}
			
			try {
				Regex validation_regexp = new Regex (_pattern);
				
				if (validation_regexp != null) {
					this.valid = validation_regexp.match (this.text);
				}

			} catch (Error error) {
				warning (error.message);
			}
		}
	}
}