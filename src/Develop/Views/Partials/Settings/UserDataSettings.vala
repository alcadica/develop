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

namespace Alcadica.Develop.Views.Partials.Settings { 
	public class UserDataSettings : SettingsBase {
		public Forms.FormUserData form = new Forms.FormUserData ();
		public HeaderLabel title = new HeaderLabel (_("User settings"));

		construct {
			Services.UserSettings settings = new Services.UserSettings ();

			title.set_xalign (0);
			
			this.add (title);
			this.add (this.form);

			this.form.user_name.text = settings.user_name;	
			this.form.user_email.text = settings.user_email;	
			this.form.user_github_url.text = settings.user_github_url;	
			this.form.user_website_url.text = settings.user_website_url;	

			this.form.user_name.changed.connect (() => {
				settings.user_name = this.form.user_name.text;
			});

			this.form.user_email.changed.connect (() => {
				settings.user_email = this.form.user_email.text;
			});

			this.form.user_github_url.changed.connect (() => {
				settings.user_github_url = this.form.user_github_url.text;
			});

			this.form.user_website_url.changed.connect (() => {
				settings.user_website_url = this.form.user_website_url.text;
			});
		}
	}
}