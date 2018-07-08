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

namespace Alcadica.Develop.Widgets.Editor {
	public class Toolbar : Gtk.Toolbar {
		public ToolButton create_project { get; set; }
		public ToolButton open_project { get; set; }
		public signal void project_did_created (string project_file_path);
		public signal void project_did_selected (string filepath);

		construct {
			this.create_project = new ToolButton (new Image.from_icon_name ("document-new", IconSize.SMALL_TOOLBAR), null);
			this.open_project = new ToolButton (new Image.from_icon_name ("document-open", IconSize.SMALL_TOOLBAR), null);

			this.add (this.create_project);
			this.add (this.open_project);

			this.bind_buttons ();
		}

		protected void bind_buttons () {
			this.create_project.clicked.connect (() => {
				var window = new Dialogs.DialogCreateProject ();

				window.show ();
				//  this.project_did_created ();
			});
			
			this.open_project.clicked.connect (() => {
				List<string> files = Develop.Services.FileSystem.choose_file ("Choose project", Alcadica.LibValaProject.PROJECT_FILENAME);

				if (files.length () > 0) {
					this.project_did_selected (files.nth_data (0));
				}
			});
		}
	}
}