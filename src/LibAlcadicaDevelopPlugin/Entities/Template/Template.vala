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
namespace Alcadica.Develop.Plugins.Entities.Template { 
    public abstract class Template : Object {
		public bool is_valid {
			get {
				var count = 0;
				var length = this.tokens.length ();

				for (int i = 0; i < length; i++) {
					if (this.tokens.nth_data (i).is_valid) {
						count += 1;
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
		public string template_dir { get; set; }
		public string template_name { get; set; }

		private void set_form_element_validation_state (Common.FormField item, TemplateToken token) {
			token.validation_state_did_change.connect (state => {
				item.validity_state_did_change (state);
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
		
		public abstract void on_request_create ();
	}
}