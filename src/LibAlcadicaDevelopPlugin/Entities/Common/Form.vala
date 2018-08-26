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
	public enum FormFieldType {
		Directory,
		File,
		Number,
		TextMultiple,
		Text
	}
	
	public class FormField<T> : Object {
		protected bool _is_valid { get; set; }
		public Form parent_form = null;
		public FormFieldType field_type { get; set; }
		public signal void on_change (T value);
		public signal void validity_state_did_change (bool state);
		public bool is_valid {
			get {
				return _is_valid;
			}
			set {
				_is_valid = value;
				validity_state_did_change (_is_valid);
				
				if (parent_form != null) {
					parent_form.on_field_validity_state_change (this.field_name, this);
				}
			}
		}
		public string field_label { get; set; }
		public string field_name { get; set; }
		public T default_value { get; set; }

		public FormField (string field_name, string field_label) {
			this.field_name = field_name;
			this.field_label = field_label;
		}

		public void subscribe_to_form (Form form) {
			this.parent_form = form;
			form.fields.append (this);
		}

		public void reset () {
			this.is_valid = false;
		}
	}

	public class FormFieldDirectory : FormField<File> {
		public FormFieldDirectory (string field_name, string field_label) {
			base (field_name, field_label);
			this.field_type = FormFieldType.Directory;
		}
	}

	public class FormFieldFile : FormField<File> {
		public FormFieldFile (string field_name, string field_label) {
			base (field_name, field_label);
			this.field_type = FormFieldType.File;
		}
	}

	public class FormFieldSelect : FormField<string> {
		public List<KeyValuePair<int, string>> options = new List<KeyValuePair<int, string>> ();
		
		public FormFieldSelect (string field_name, string field_label) {
			base (field_name, field_label);
			this.field_type = FormFieldType.TextMultiple;
		}

		public void add_option (int key, string value) {
			this.options.append (new KeyValuePair<int, string> (key, value));
		}

		public KeyValuePair<int, string>? get_option (int key) {
			KeyValuePair<int, string>? option = null;

			for (int i = 0; i < this.options.length (); i++) {
				var current = this.options.nth_data (i);

				if (current.key == key) {
					option = current;
					break;
				}
			}

			return option;
		}

		public bool remove_option (int key) {
			var current = this.get_option (key);

			if (current == null) {
				return false;
			}

			uint initial_length = this.options.length ();

			this.options.remove (current);

			return this.options.length () < initial_length; 
		}
	}

	public class FormFieldText : FormField<string> {
		public FormFieldText (string field_name, string field_label) {
			base (field_name, field_label);
			this.field_type = FormFieldType.Text;
		}
	}
	
	public class Form : Object {
		public List<FormField> fields = new List<FormField> ();
		public bool is_valid {
			get {
				int count = 0;

				foreach (var field in fields) {
					if (field.is_valid) {
						count += 1;
					}
				}
				return count == fields.length ();
			}
		}
		public string title { get; set; }
		public signal void on_item_change (string name, FormField instance);
		public signal void on_field_validity_state_change (string field_name, FormField instance);

		public FormField add_directory (string name, string label) {
			FormField item = new FormFieldDirectory (name, label);
			
			item.subscribe_to_form (this);

			item.on_change.connect(() => {
				this.on_item_change (name, item);
			});
			
			return item;
		}

		public FormField add_file (string name, string label) {
			FormField item = new FormFieldFile (name, label);
			
			item.subscribe_to_form (this);

			item.on_change.connect(() => {
				this.on_item_change (name, item);
			});

			return item;
		}

		public FormFieldSelect add_select (string name, string label) {
			FormFieldSelect item = new FormFieldSelect (name, label);
			
			item.subscribe_to_form (this);

			item.on_change.connect(() => {
				this.on_item_change (name, item);
			});

			return item;
		}

		public FormField add_text (string name, string label) {
			FormField item = new FormFieldText (name, label);
			
			item.subscribe_to_form (this);

			item.on_change.connect(() => {
				this.on_item_change (name, item);
			});

			return item;
		}

		public FormField? get_by_name (string name) {
			FormField? item = null;

			for (int i = 0; i < this.fields.length (); i++) {
				var current = this.fields.nth_data (i);

				if (current.field_name == name) {
					item = current;
					break;
				}
			}

			return item;
		}

		public void reset () {
			foreach (var field in fields) {
				field.reset ();
			}
		}
	}
}