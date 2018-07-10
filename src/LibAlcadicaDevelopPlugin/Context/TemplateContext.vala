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

namespace Alcadica.Develop.Plugins.Entities {
	public class TemplateContext : Object {
		protected List<Template.Template> subscribed_templates = new List<Template.Template> ();

		public List<string> get_subscribed_templates_names () {
			List<string> list = new List<string> ();

			debug ("Getting " + subscribed_templates.length ().to_string () + " templates");

			foreach (var subscription in subscribed_templates) {
				list.append (subscription.template_name);
			}
			
			return list;
		}

		public Template.Template? get_template_by_name (string template_name) {
			Template.Template? template = null;

			for (int i = 0; i < subscribed_templates.length (); i++) {
				if (subscribed_templates.nth_data (i).template_name == template_name) {
					template = subscribed_templates.nth_data (i);
					break;
				}
			}

			return template;
		}
		
		public bool is_subscribed (Template.Template template) {
			bool result = this.get_template_by_name (template.template_name) != null;

			debug ("Template " + template.template_name + " is " + (result ? "" : "not") + " subscribed");
			
			return result;
		}
		
		public void subscribe (Template.Template template) {
			debug ("Subscribing template " + template.template_name);

			if (this.is_subscribed (template)) {
				info ("Template " + template.template_name + " is already subscribed, aborting");
				return;
			}
			
			this.subscribed_templates.append (template);

			debug ("Template " + template.template_name + " subscribed");
		}
	}
}