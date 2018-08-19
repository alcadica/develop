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
using Alcadica.Develop.Plugins.Services;

namespace Alcadica.Develop.Plugins.Entities.Template { 
    public abstract class Template : Object {
		public bool is_valid {
			get {
				var count = 0;
				var length = this.tokens.length ();

				for (int i = 0; i < length; i++) {
					if (this.tokens.nth_data (i).is_valid) {
						count = count + 1;
					}
				}

				return count == length;
			}
		}
		public Common.Form form = new Common.Form ();
		public List<string> files = new List<string> ();
		public List<TemplateToken> tokens = new List<TemplateToken> ();
		public string template_description { get; set; }
		public string template_icon_name { get; set; }
		public string template_name { get; set; }
		public signal void template_property_did_change (string name, TemplateToken token);

		private void set_form_element_validation_state (Common.FormField item, TemplateToken token) {
			token.validation_state_did_change.connect (state => {
				item.validity_state_did_change (state);
				this.template_property_did_change (token.token_name, token);
			});
		}

		protected TemplateToken add_file_selector_token (string token_label, string token_name) {
			TemplateToken token = new TemplateToken (token_label, token_name, "");
			var field = this.form.add_file (token_name, token_label);

			field.on_change.connect (file => {
				token.token_value = ((File) file).get_path ();
			});
			this.tokens.append (token);
			this.set_form_element_validation_state(field, token);

			return token;
		}

		protected TemplateToken add_folder_selector_token (string token_label, string token_name) {
			TemplateToken token = new TemplateToken (token_label, token_name, "");
			var field = this.form.add_directory (token_name, token_label);

			field.on_change.connect (file => {
				token.token_value = ((File) file).get_path ();
			});
			this.tokens.append (token);
			this.set_form_element_validation_state(field, token);

			return token;
		}
		
		protected TemplateToken add_token (string token_label, string token_name, string token_value = "") {
			TemplateToken token = new TemplateToken (token_label, token_name, token_value);
			var field = this.form.add_text (token_name, token_label);

			field.on_change.connect (text => {
				token.token_value = (string) text;
			});
			this.tokens.append (token);
			this.set_form_element_validation_state(field, token);

			return token;
		}

		protected TemplateToken add_token_list (string token_label, string token_name, List<Common.KeyValuePair<int, string>> token_values) {
			TemplateToken token = new TemplateToken (token_label, token_name, "");
			var field = this.form.add_select (token_name, token_label);

			foreach (Common.KeyValuePair<int, string> kvp in token_values) {
				field.add_option (kvp.key, kvp.value);
			}

			field.on_change.connect (value => {
				token.token_value = ((int) value).to_string ();
			});

			this.tokens.append (token);
			this.set_form_element_validation_state (field, token);

			return token;
		}

		protected TemplateToken? get_token (string token_name) {
			TemplateToken? result = null;

			for (int i = 0; i < this.tokens.length (); i++) {
				var _item = this.tokens.nth_data (i);

				if (_item.token_name == token_name) {
					result = _item;
					break;
				}
			}

			return result;
		}

		protected List<File> parse_files_with_tokens () {
			List<File> parsed_files = new List<File> ();

			foreach (var filepath in this.files) {
				File file = File.new_for_path (filepath);
				
				if (FileSystemService.is_file (file)) {
					string content = FileSystemService.read_file_content (filepath);
	
					foreach (var token in this.tokens) {
						content = content.replace (token.token, token.token_value);
						FileSystemService.replace_file_content (file, content);
					}
				}

				parsed_files.append (file);
			}

			return parsed_files;
		}

		protected void set_files_from_directory (File directory) {
			List<string> filepaths = FileSystemService.read_dir_recursive (directory);

			foreach (string filepath in filepaths) {
				this.files.append (filepath);
			}
		}

		protected void write_parsed_files (List<File> files) {
			foreach (File file in files) {
				FileSystemService.write (file);
			}
		}
		
		public abstract void on_request_create ();
	}
}