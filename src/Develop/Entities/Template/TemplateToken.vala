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
namespace Alcadica.Entities.Template { 
    public class TemplateToken : Object { 
		public static string delimiter_start = "{{";
		public static string delimiter_end = "}}";

		public string token { get; set; }
		public string token_value { get; set; }

		public TemplateToken (string name, string token_value) {
			this.token = TemplateToken.delimiter_start + name + TemplateToken.delimiter_end;
			this.token_value = token_value;
		}
	}
}