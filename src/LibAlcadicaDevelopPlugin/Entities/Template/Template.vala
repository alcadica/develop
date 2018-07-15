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
namespace Alcadica.Develop.Plugins.Entities.Template { 
    public class Template : Object {
		public List<string> files = new List<string> ();
		public List<TemplateToken> tokens = new List<TemplateToken> ();
		public string template_description { get; set; }
		public string template_icon_name { get; set; }
		public string template_dir { get; set; }
		public string template_name { get; set; }

		protected TemplateToken add_token (string token_label, string token_name, string token_value) {
			TemplateToken token = new TemplateToken (token_label, token_name, token_value);

			this.tokens.append (token);

			return token;
		}
	}
}