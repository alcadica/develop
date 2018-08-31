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

namespace Alcadica.Develop.Views { 
	public class MainView : Paned {
		private Stack stack;
		
		construct {
			var action_manager = Services.ActionManager.instance;
			var application_context = Services.Editor.PluginContext.context.application;
			var editor = new Editor ();
			var paned = new Paned (Orientation.HORIZONTAL);
			var project_creator = new ProjectCreator ();
			var settings = new Settings ();
			
			stack = new Stack ();
			stack.add_named (editor, Actions.Window.SHOW_EDITOR);
			stack.add_named (project_creator, Actions.Window.SHOW_PROJECT_CREATION);
			stack.add_named (settings, Actions.Window.SHOW_SETTINGS);
			
			this.orientation = Orientation.HORIZONTAL;
			this.pack1 (stack, false, false);
			this.show_child_on_activate (Actions.Window.SHOW_EDITOR);
			this.show_child_on_activate (Actions.Window.SHOW_PROJECT_CREATION);
			this.show_child_on_activate (Actions.Window.SHOW_SETTINGS);

			application_context.show_editors.connect (() => {
				show_child_on_activate (Actions.Window.SHOW_EDITOR);
			});

			application_context.show_settings.connect (() => {
				show_child_on_activate (Actions.Window.SHOW_SETTINGS);
			});

			application_context.show_templates.connect (() => {
				show_child_on_activate (Actions.Window.SHOW_PROJECT_CREATION);
			});
		}

		private void show_child_on_activate (string child) {
			Services.ActionManager.instance.get_action (child).activate.connect (() => {
				stack.set_visible_child_full (child, StackTransitionType.CROSSFADE);
			});
		}
	}
}