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

using Alcadica.Develop.Plugins.Entities;
using Alcadica.Develop.Plugins.Services;

namespace com.alcadica.develop.plugins.entities { 
	public class SwitchboardWidgetTemplate : Template.Template {
		construct {
			template_description = _("Creates a Switchboard (the settings App) widget");
			template_icon_name = "preferences-desktop";
			template_name = _("Switchboard widget");

			var widget_type = this.form.add_select (_("Widget type"), "widget_type");

			widget_type.add_option (1, _("Personal"));
			widget_type.add_option (2, _("Hardware"));
			widget_type.add_option (3, _("Network & Wireless"));
			widget_type.add_option (4, _("Administration"));
			
			var widget_name = this.form.add_text (_("Widget name"), "widget_name");
			var widget_folder = this.form.add_directory (_("Source code folder"), "source_folder");
		}

		public override void on_request_create () {
			
		}
	}
}
