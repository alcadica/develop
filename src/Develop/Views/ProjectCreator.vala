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
using Gtk;

using Alcadica.Develop.Plugins.Entities.Common;
using Alcadica.Develop.Plugins.Entities.Template;
using Alcadica.Develop.Services.Editor;

namespace Alcadica.Develop.Views { 
	public class ProjectCreator : Paned {
		private Alcadica.Develop.Plugins.Entities.Template.Template? current_template { get; set; }
		private Alcadica.Widgets.ActionBar detail_action_bar;
		private Box template_detail;
		private List<string> subscribed_templates;
		private ListBox category_list;
		private signal void template_did_select (string name);
		
		construct {
			var actions_box = new Box (Orientation.HORIZONTAL, 36);
			var category_stack = new Stack ();
			var template_stack = new Stack ();

			this.category_list = new ListBox ();
			this.detail_action_bar = new Alcadica.Widgets.ActionBar ();
			this.subscribed_templates = new List<string> ();
			this.template_detail = new Box (Orientation.VERTICAL, 36);

			actions_box.set_center_widget (this.detail_action_bar);
			
			this.template_detail.pack_end (actions_box);
			this.template_detail.set_homogeneous (false);

			this.category_list.selection_mode = SelectionMode.SINGLE;
			this.orientation = Orientation.HORIZONTAL;

			category_stack.add (this.category_list);
			template_stack.add (this.template_detail);

			this.pack1 (category_stack, true, false);
			this.pack2 (template_stack, true, false);

			PluginContext.context.application.show_templates.connect (() => {
				this.empty_list ();
				this.populate_category_list ();
				this.show_all ();
			});
			
			this.category_list.row_selected.connect (row => {
				this.template_did_select (this.subscribed_templates.nth_data (row.get_index ()));
			});

			this.detail_action_bar.secondary_action.clicked.connect(() => {
				if (this.current_template.form != null) {
					this.current_template.form.reset ();
				}
				
				this.populate_template_detail (this.current_template.template_name);
				this.detail_action_bar.disable ();
			});

			this.template_did_select.connect (this.populate_template_detail);
		}

		private void create_form_item (FormField field, Grid detail_grid) {
			var entry = this.get_field (field);

			if (entry == null) {
				return;
			}

			entry.changed.connect(value => {
				field.on_change (value);
			});

			field.validity_state_did_change.connect(state => {
				entry.validity_state_did_change (state);
			});
			
			debug (@"Adding field " + field.field_label + " to form");

			detail_grid.add (entry);
		}

		private void empty_list () {
			debug ("Emptying templates list");

			List<weak Gtk.Widget> children = this.category_list.get_children ();
			
			foreach (Gtk.Widget element in children) {
				this.category_list.remove (element);
			}
		}

		private Alcadica.Widgets.IEntryWidget? get_field (FormField field) {
			Alcadica.Widgets.IEntryWidget? widget = null;
			
			switch (field.field_type) {
				case FormFieldType.Directory:
					widget = new Alcadica.Widgets.DirectorySelectorWithLabel (_("Choose a directory"), field.field_label);
				break;
				case FormFieldType.File:
					widget = new Alcadica.Widgets.FileSelectorWithLabel (_("Choose a file"), field.field_label);
				break;
				case FormFieldType.Number:

				break;
				case FormFieldType.Text:
					widget = new Alcadica.Widgets.EntryWithLabel (field.field_label);
				break;
				case FormFieldType.TextMultiple:
					FormFieldSelect _field = (FormFieldSelect) field; 
					widget = new Alcadica.Widgets.ComboBoxWithLabel (field.field_label);

					foreach (var option in _field.options) {
						((Alcadica.Widgets.ComboBoxWithLabel) widget).add_option (option.key, option.value);
					}

					if (_field.options.length () > 0) {
						((Alcadica.Widgets.ComboBoxWithLabel) widget).value = _field.options.nth_data (0).key;
					}
				break;
			}
			
			return widget;
		}
		
		private Widget? get_template_list_item (string item_name) {
			var template = PluginContext.context.template.get_template_by_name (item_name);
			
			if (template == null) {
				debug (@"No instance for template $item_name");
				return null;
			}

			string template_icon_name;

			if (template.template_icon_name == "" || template.template_icon_name == null) {
				template_icon_name = "image-missing";
			} else {
				template_icon_name = template.template_icon_name;
			}
			
			var grid = new Grid ();
			var template_description = new Label (template.template_description);
			var template_icon = new Image.from_icon_name (template_icon_name, IconSize.DIALOG);
			var template_name = new Label (template.template_name);

			template_name.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
			template_name.ellipsize = Pango.EllipsizeMode.END;
			template_name.xalign = 0;
			template_name.valign = Gtk.Align.END;

			grid.column_spacing = 12;
			grid.orientation = Orientation.HORIZONTAL;
			grid.attach (template_icon, 0, 0, 1, 2);
			grid.attach (template_name, 1, 0, 1, 1);
			grid.attach (template_description, 1, 1, 1, 1);

			debug (@"Created template list item $item_name");

			return grid;
		}

		private Widget? get_template_detail(Template template) {
			var detail_grid = new Grid ();
			var template_title = new Label (template.template_name);
			var icon = new Image.from_icon_name (template.template_icon_name, IconSize.DIALOG);

			this.current_template = template;

			detail_grid.orientation = Orientation.VERTICAL;
			template_title.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
			template_title.justify = Justification.CENTER;
			
			this.detail_action_bar.disable ();
			this.detail_action_bar.primary_action.clicked.disconnect (this.on_click_request_create);
			this.detail_action_bar.primary_action.clicked.connect (this.on_click_request_create);
			
			detail_grid.add (icon);
			detail_grid.add (template_title);

			foreach (FormField field in template.form.fields) {
				this.create_form_item(field, detail_grid);
			}

			template.form.on_item_change.connect (() => {
				this.detail_action_bar.enable_secondary_action ();
			});		

			template.form.on_field_validity_state_change.connect (() => {
				if (template.form.is_valid) {
					this.detail_action_bar.enable_primary_action ();
				} else {
					this.detail_action_bar.disable_primary_action ();
				}
			});
			
			return detail_grid;
		}

		private void on_click_request_create () {
			this.current_template.on_request_create ();
		}

		private void populate_category_list () {
			this.subscribed_templates = PluginContext.context.template.get_subscribed_templates_names ();
			
			foreach (var template_name in subscribed_templates) {
				debug (@"Adding \"$template_name\" to templates list.");
	
				Widget? item = this.get_template_list_item (template_name);
	
				if (item == null) {
					continue;
				}
				
				this.category_list.add (item);
			}
		}

		private void populate_template_detail (string template_name) {
			Template? template = PluginContext.context.template.get_template_by_name (template_name);

			debug (@"Selected $template_name");

			if (template == null) {
				warning (@"Template $template_name is missing, aborting");
				return;
			}

			var box = new Box (Orientation.HORIZONTAL, 36);
			var detail_form = this.get_template_detail (template);
			var previous_widget = this.template_detail.get_center_widget ();

			if (previous_widget != null) {
				debug ("Removing previous template form");
				previous_widget.dispose ();
			}

			box.set_center_widget (detail_form);
			box.set_hexpand (false);

			this.template_detail.set_center_widget (box);
			this.show_all ();
		}
	}
}