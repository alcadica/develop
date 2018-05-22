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

namespace Alcadica.Views {
    
    public class MainView : Paned {       
        construct {
            string view_first_run = "view_first_run";
            string view_settings = "view_settings";
            string view_welcome = "view_welcome";
            string view_project_creation = "view_project_creation";

            Partials.Settings.UserDataSettingsFirstRun first_run = new Partials.Settings.UserDataSettingsFirstRun ();
            ProjectEditingView project_editing = new ProjectEditingView ();
            Services.ActionManager manager = Services.ActionManager.instance;
            SettingsView settings = new SettingsView ();
            Stack stack = new Stack ();
            string? last_visible_child_name;
            WelcomeView welcome = new WelcomeView ();
            
            orientation = Orientation.HORIZONTAL;
            
            stack.add_named (welcome, view_welcome);
            stack.add_named (project_editing, view_project_creation);
            stack.add_named (settings, view_settings);
            stack.add_named (first_run, view_first_run);
            
            this.pack1(stack, true, false);

            project_editing.on_undo.connect(() => {
                stack.set_visible_child_full(view_welcome, StackTransitionType.SLIDE_RIGHT);
                project_editing.reset ();
            });

            welcome.app.connect(() => {
                stack.set_visible_child_full(view_project_creation, StackTransitionType.SLIDE_LEFT);
                project_editing.show_app_form ();
            });
            
            welcome.switchboard.connect(() => {
                stack.set_visible_child_full(view_project_creation, StackTransitionType.SLIDE_LEFT);
                project_editing.show_form_switchboard ();
            });
            
            welcome.wingpanel.connect(() => {
                stack.set_visible_child_full(view_project_creation, StackTransitionType.SLIDE_LEFT);
                project_editing.show_form_wingpanel ();
            });

            manager.get_action (Actions.Window.FIRST_RUN).activate.connect (() => {
                last_visible_child_name = view_welcome;
                stack.set_visible_child_full(view_first_run, StackTransitionType.CROSSFADE);
            });

            manager.get_action (Actions.Window.FIRST_RUN_END).activate.connect (() => {
                stack.set_visible_child_full(last_visible_child_name, StackTransitionType.CROSSFADE);
            });

            manager.get_action (Actions.Window.SETTINGS_OPEN).activate.connect (() => {
                last_visible_child_name = stack.get_visible_child_name ();
                stack.set_visible_child_full(view_settings, StackTransitionType.CROSSFADE);
            });

            manager.get_action (Actions.Window.SETTINGS_CLOSE).activate.connect (() => {
                if (last_visible_child_name == null) {
                    last_visible_child_name = view_welcome;
                }
                
                stack.set_visible_child_full(last_visible_child_name, StackTransitionType.CROSSFADE);

                last_visible_child_name = null;
            });

            manager.get_action (Actions.Window.SHOW_WELCOME_VIEW).activate.connect (() => {
                stack.set_visible_child_full(view_welcome, StackTransitionType.SLIDE_RIGHT);
            });

            manager.get_action (Actions.ProjectEditing.TEMPLATE_DID_COPY).activate.connect(() => {
                stack.set_visible_child_full(view_welcome, StackTransitionType.CROSSFADE);
            });
        }
    }
}