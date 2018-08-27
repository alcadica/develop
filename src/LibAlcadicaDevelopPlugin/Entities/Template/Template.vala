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
		public Alcadica.Develop.Plugins.Entities.Common.Form form = new Alcadica.Develop.Plugins.Entities.Common.Form ();
		public List<TemplateFile> files = new List<TemplateFile> ();
		public List<TemplateToken> tokens = new List<TemplateToken> ();
		public string template_description { get; set; }
		public string template_icon_name { get; set; }
		public string template_name { get; set; }
		public signal void on_template_created (string project_file_path);

		public abstract void on_request_create ();

		public void add_file (File file) {
			TemplateFile template_file = new TemplateFile ();
			
			template_file.path = file.get_path ();

			if (FileSystemService.is_file (file)) {
				template_file.content = FileSystemService.read_file_content (template_file.path);
				template_file.file_type = TemplateFileType.FILE;
			} else {
				template_file.file_type = TemplateFileType.DIRECTORY;
			}
			
			this.files.append (template_file);
		}

		public void add_files_from_directory (string path) {
			List<string> _files = FileSystemService.read_dir_recursive (File.new_for_path (path));
			
			foreach (string file_path in _files) {
				this.add_file (File.new_for_path (file_path));
			}
		}

		public TemplateToken add_token (string name) {
			TemplateToken token = new TemplateToken (name);

			this.tokens.append (token);

			return token;
		}

		public void change_files_directory (string from, string to) {
			foreach (TemplateFile file in this.files) {
				file.path = file.path.replace (from, to);
			}
		}

		public TemplateToken? get_token (string token_name) {
			TemplateToken? result = null;

			for (int i = 0; i < this.tokens.length (); i++) {
				var _token = this.tokens.nth_data (i);

				if (_token.token_name == token_name) {
					result = _token;
					break;
				}
			}

			return result;
		}
		
		public string parse_content (string content) {
			string result = content;

			foreach (var token in tokens) {
				result = result.replace (token.token, token.token_value);
			}

			return result;
		}

		public void parse_files_content () {
			foreach (TemplateFile file in this.files) {
				if (file.file_type == TemplateFileType.FILE) {
					file.content = parse_content (file.content);
				}
			}
		}

		public void unset_files () {
			this.files = new List<TemplateFile> ();
		}

		public void write_files () {
			foreach (TemplateFile file in this.files) {
				FileSystemService.write_file (file.path, file.content);
			}
		}
	}
}