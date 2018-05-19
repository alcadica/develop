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
using Alcadica.Widgets;
using Granite;
using Gtk;

namespace Alcadica.Views.Partials.Forms { 
	public class FormUserData : FormBase { 
		private const string github_url = "https://github.com";
		public EntryWithLabel user_name { get; set; }
		public EntryWithLabel user_email { get; set; }
		public EntryWithLabel user_github_url { get; set; }
		public EntryWithLabel user_website_url { get; set; }

		construct {
			user_name = new EntryWithLabel (_("Name:"), _("John Doe"));
			user_email = new EntryWithLabel (_("Email:"), _("myemail@gmail.com"));
			user_github_url = new EntryWithLabel (_("Personal github address:"), _("https://github.com/yourname"));
			user_website_url = new EntryWithLabel (_("Personal website:"), _("https://www.mywebsite.com"));

			user_name.entry.pattern = Alcadica.CommonRegEx.USER_NAME;
			user_email.entry.pattern = Alcadica.CommonRegEx.USER_EMAIL;
			user_github_url.entry.pattern = Alcadica.CommonRegEx.URL;
			user_website_url.entry.pattern = Alcadica.CommonRegEx.URL;
			user_website_url.optional = true;

			attach (user_name, 0, 0, 1, 1);
			attach (user_email, 0, 1, 1, 1);
			attach (user_github_url, 0, 2, 1, 1);
			attach (user_website_url, 0, 3, 1, 1);

			user_email.changed.connect (() => {
				validate ();
			});

			user_github_url.changed.connect (() => {
				validate ();
			});

			user_name.changed.connect (() => {
				validate ();
			});

			focusin.connect (() => {
				if (user_name.text != "") {
					user_email.focusin ();
				} else {
					user_name.focusin ();
				}
			});

			fill_from_settings ();
		}

		public void fill_from_settings () {
			var settings = new Services.UserSettings ();

			if (settings.user_name != null && settings.user_name != "") {
				this.user_name.text = settings.user_name;
			} else {
				this.user_name.text = Environment.get_user_name ();
			}

			if (settings.user_email != null && settings.user_email != "") {
				this.user_email.text = settings.user_email;
			}

			if (settings.user_github_url != null && settings.user_github_url != "") {
				this.user_github_url.text = settings.user_github_url;
			} else {
				this.user_github_url.text = string.join ("/", github_url, this.user_name.text);
			}

			if (settings.user_website_url != null && settings.user_website_url != "") {
				this.user_website_url.text = settings.user_website_url;
			}
		}

		public override void reset () {
			this.is_valid = false;
			this.user_name.text = Environment.get_user_name ();
			this.user_email.text = "";
			this.user_github_url.text = "";
			this.user_website_url.text = "";
		}

		public override void validate () {
			this.user_name.entry.validate ();
			this.user_email.entry.validate ();
			this.user_github_url.entry.validate ();
			this.user_website_url.entry.validate ();
			
			this.is_valid = this.user_name.entry.valid && this.user_email.entry.valid && this.user_github_url.entry.valid;
			this.on_validate ();
		}
	}
}