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
using Alcadica.Develop.Plugins.Entities.Application;
using Gtk;

namespace Alcadica.Widgets.Editor {
	public class BottomBar : Gtk.Toolbar {
		construct {
			var appcontext = Develop.Services.Editor.PluginContext.context.application;
			var editor_status_pane = new Gtk.ToolItem ();
			var editor_status_pane_label = new Gtk.Label (null);
			
			this.toolbar_style = Gtk.ToolbarStyle.BOTH_HORIZ;
			this.insert (editor_status_pane, 0);

			editor_status_pane.add (editor_status_pane_label);

			appcontext.bottom_toolbar.state_did_change.connect (state => {
				switch (state) {
					case BottomToolbarContextStatus.Error:
						editor_status_pane_label.label = _("Error");
					break;
					case BottomToolbarContextStatus.Idle:
						editor_status_pane_label.label = _("Idle");
					break;
					case BottomToolbarContextStatus.Loading:
						editor_status_pane_label.label = _("Loading");
					break;
					case BottomToolbarContextStatus.RunningTask:
						editor_status_pane_label.label = _("Running task");
					break;
				}
			});

			appcontext.bottom_toolbar.state = BottomToolbarContextStatus.Idle;
		}
	}
}