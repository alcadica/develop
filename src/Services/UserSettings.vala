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

namespace Alcadica.Services {
    public class UserSettings : Granite.Services.Settings {
        public bool is_first_run { get; set; }
        public string user_email { get; set; }
        public string user_github_url { get; set; }
        public string user_name { get; set; }
        public string user_website_url { get; set; }

        public UserSettings () {
            base (APP_ID);
        }

        protected override void verify (string key) {
            switch (key) {
                case "user-email":
                    if (this.user_email == "" || this.user_email == null) {
                        this.user_email = "";
                    }
                break;
                case "user-github-url":
                    if (this.user_github_url == "" || this.user_github_url == null) {
                        this.user_github_url = "http://github.com/";
                    }
                break;
                case "user-name":
                    if (this.user_name == "" || this.user_name == null) {
                        this.user_name = Environment.get_user_name ();
                    }
                break;
                case "user-website-url":
                    if (this.user_website_url == "" || this.user_website_url == null) {
                        this.user_website_url = "";
                    }
                break;
            }
        }
    }
}
