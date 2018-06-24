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
	public class EditorList : Object {
		private Editor _current = null;
		public Editor current { 
			get {
				return _current;
			}
			set {
				_current = value;
				_current.did_become_current ();
			} 
		}
		public List<Editor> editors = new List<Editor> ();
		public signal void on_current_change (Editor editor);
		public signal void on_list_change ();

		public void add (string filename) {
			Editor editor = new Editor ();

			editor.filename = filename;
			editor.file = File.new_for_path (filename);
			editor.will_open ();

			if (_current == null) {
				current = editor;
			}

			editors.append (editor);
		}
		
		public bool is_open (Editor editor) {
			return is_open_by_filename (editor.filename);
		}
		
		public bool is_open_by_filename (string filename) {
			bool result = false;

			for (int i = 0; i < editors.length (); i++) {
				if (editors.nth_data (i).filename == filename) {
					result = true;
					break;
				}
			}

			return result;
		}

		public bool remove (Editor editor) {
			if (!is_open_by_filename (editor.filename)) {
				return false;
			}

			uint length_before = editors.length ();

			editor.will_close ();

			editors.remove (editor);

			uint length_after = editors.length ();

			return length_after < length_before;
		}
	}
}