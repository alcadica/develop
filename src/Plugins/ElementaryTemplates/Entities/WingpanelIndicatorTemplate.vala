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

using Alcadica.Develop.Plugins.Entities.Template;

namespace com.alcadica.develop.plugins.entities { 
	public class WingpanelIndicatorTemplate : Template {
		construct {
			template_name = _("Wingpanel indicator");
			template_icon_name = "package-x-generic";
			template_description = _("Creates an elementary OS application from scratch");

			var indicator_name = this.add_token (_("Indicator name"), "indicatorname");

			indicator_name.validate.connect(value => {
				indicator_name.is_valid = true;
			});
		}

		public override void on_request_create () 
		{
			
		}
	}
}