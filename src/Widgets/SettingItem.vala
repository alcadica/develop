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
using Granite;
using Gtk;
using Alcadica.Views.Partials;

namespace Alcadica.Widgets {
	public class SettingItem : ListBox { 
		public Image? icon = null;
		public Grid grid { get; set; }
		public Label subtitle_label { get; set; }
		public Label title_label { get; set; }
		public string subtitle { get; set; }
		public string title { get; set; }
		
		public SettingItem (string title, string subtitle, string? icon_name = null) {
			this.grid = new Gtk.Grid ();
			
			this.subtitle_label = new Gtk.Label (subtitle);
			this.title_label = new Gtk.Label (title);

			this.title_label.get_style_context ().add_class (STYLE_CLASS_H3_LABEL);
			this.title_label.ellipsize = Pango.EllipsizeMode.END;
			this.title_label.xalign = 0;
			this.title_label.valign = Gtk.Align.END;

			this.subtitle_label.use_markup = true;
			this.subtitle_label.ellipsize = Pango.EllipsizeMode.END;
			this.subtitle_label.xalign = 0;
			this.subtitle_label.valign = Gtk.Align.START;

			this.grid.margin = 6;
			this.grid.column_spacing = 6;

			if (icon_name != null) {
				this.icon = new Gtk.Image.from_icon_name (icon_name.to_string (), IconSize.LARGE_TOOLBAR);
				this.grid.attach (this.icon, 0, 0, 1, 2);
			}
			
			this.grid.attach (title_label, 1, 0, 1, 1);
			this.grid.attach (subtitle_label, 1, 1, 1, 1);

			this.add (this.grid);
		}
	}
}
    