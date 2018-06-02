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

namespace Alcadica.Views.Partials.Settings { 
	public class UserDataSettingsFirstRun : Gtk.Box {
		public Alcadica.Widgets.ActionBar actions = new Alcadica.Widgets.ActionBar ();
		public UserDataSettings userdata = new UserDataSettings ();
		
		construct {
			Grid grid = new Grid ();
			Image icon = new Image.from_icon_name (APP_ID, IconSize.DIALOG);
			Label welcome_label = new Label (_("First run setup"));
			Label welcome_label_subtitle = new Label (_("Before proceeding I'd love to know more about you"));
			Label welcome_label_disclaimer = new Label (_("Your data will not be stored in a server"));
			Services.ActionManager manager = Services.ActionManager.instance;

			icon.pixel_size = 128;
			
			actions.margin_top = 20;
			grid.orientation = Orientation.VERTICAL;
			this.orientation = Orientation.VERTICAL;
			icon.margin_bottom = 20;
			welcome_label_disclaimer.margin_bottom = 20;

			welcome_label.get_style_context ().add_class (STYLE_CLASS_H1_LABEL);
			welcome_label_subtitle.get_style_context ().add_class (STYLE_CLASS_PRIMARY_LABEL);
			welcome_label_disclaimer.get_style_context ().add_class ("dim-label");

			grid.add (icon);
			grid.add (welcome_label);
			grid.add (welcome_label_subtitle);
			grid.add (welcome_label_disclaimer);
			grid.add (userdata);
			grid.add (actions);

			this.actions.primary_action.label = _("Save user data");
			this.set_halign (Align.CENTER);
			this.set_center_widget (grid);

			this.actions.primary_action.clicked.connect (() => {
				manager.dispatch (Actions.Window.FIRST_RUN_END);
			});
			
			this.userdata.form.on_validate.connect (() => {
				if (this.userdata.form.is_valid) {
					this.actions.enable_primary_action ();
				} else {
					this.actions.disable_primary_action ();
				}
			});
			
			manager.get_action (Actions.Window.START).activate.connect (() => {
				this.userdata.title.hide ();
				this.actions.secondary_action.hide ();
				
				this.userdata.form.validate ();

				if (this.userdata.form.is_valid) {
					this.actions.enable_primary_action ();
				} else {
					this.actions.disable_primary_action ();
				}
			});
		}
	}
}