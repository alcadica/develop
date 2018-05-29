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

namespace Alcadica.Widgets.Editor {
	public class Toolbar : Gtk.Toolbar {
		public ToolButton open_project { get; set; }
		public signal void project_did_selected (string filepath);

		construct {
			this.open_project = new ToolButton (new Image.from_icon_name ("document-open", IconSize.SMALL_TOOLBAR), null);

			this.add (this.open_project);

			this.bind_buttons ();
		}

		protected void bind_buttons () {
			this.open_project.clicked.connect (() => {
				List<string> files = Services.FileSystem.choose_file ("Choose project", "project.elementaryos");

				if (files.length () > 0) {
					this.project_did_selected (files.nth_data (0));
				}
			});
		}
	}
}