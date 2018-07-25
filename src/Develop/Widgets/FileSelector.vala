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

using Gtk;

namespace Alcadica.Widgets {
	protected class SelectorWithLabelBase : Grid, IEntryWidget<File> {
		protected bool is_directory_picker { get; set; }
		protected Button button { get; set; }
		protected Label label { get; set; }
		protected string button_label { get; set; }
		protected string file_path { get; set; }
		protected string _file_pattern { get; set; }

		protected SelectorWithLabelBase (string button_label, string label) {
			this.button = new Button.with_label (button_label);
			this.button_label = button_label;
			
			this.label = new Label (label);
			this.label.margin_bottom = 4;
			this.label.set_xalign (0);
			this.label.get_style_context ().add_class (Granite.STYLE_CLASS_PRIMARY_LABEL);

			this.orientation = Orientation.VERTICAL;
			this.row_spacing = 0;
			
			this.attach (this.label, 0, 0, 1);
			this.attach (this.button, 0, 1, 2);
			this.set_column_homogeneous (true);

			this.button.clicked.connect (this.open_file_chooser);
		}

		protected void open_file_chooser () {
			string? path = null;
			string label = this.button.label;

			if (this.is_directory_picker) {
				Alcadica.Develop.Services.FileSystem.choose_directory (label);
			} else {
				Alcadica.Develop.Services.FileSystem.choose_file (label, this._file_pattern);
			}

			if (path == null) {
				return;
			}
			
			this.button.label = path;
			this.file_path = path;

			File file = File.new_for_path (path);
			this.changed (file);
		}

		public void reset () {
			this.button.label = button_label;
			this.file_path = "";
		}
	}
	
	public class DirectorySelectorWithLabel : SelectorWithLabelBase {
		public DirectorySelectorWithLabel (string button_label, string label) {
			base (button_label, label);
			this.is_directory_picker = true;
		}
	}
	
	public class FileSelectorWithLabel : SelectorWithLabelBase {
		public string file_pattern { 
			get {
				return _file_pattern;
			}
			set {
				_file_pattern = value;
			}
		}
		
		public FileSelectorWithLabel (string button_label, string label) {
			base (button_label, label);
		}
	}
}