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
using Alcadica.Views.Partials;
using Alcadica.Services;

namespace Alcadica.Views { 
    public class ProjectEditingView : Box {

        protected signal void on_reset ();
        public Forms.FormBase current_form { get; set; }
        public Forms.FormNewApp form_app = new Forms.FormNewApp ();
        public Forms.FormNewSwitchboardWidget form_switchboard = new Forms.FormNewSwitchboardWidget ();
        public Forms.FormNewWingpanelWidget form_wingpanel = new Forms.FormNewWingpanelWidget ();
        public Forms.FormUserData form_user_data = new Forms.FormUserData ();
        public signal void on_confirm ();
        public signal void on_undo ();
        public signal void on_template_creation_end (string directory);
        
        construct {
            Services.ActionManager manager = Services.ActionManager.instance;
            Alcadica.Widgets.ActionBar actions = new Alcadica.Widgets.ActionBar ();
            Stack stack = new Stack ();
            
            this.orientation = Orientation.VERTICAL;

            actions.disable_primary_action ();
            stack.add (form_app);
            stack.add (form_switchboard);
            stack.add (form_wingpanel);
            
            this.set_halign (Align.CENTER);
            this.set_center_widget (stack);
            this.pack_end (actions);
            this.set_spacing (20);

            this.on_reset.connect (() => {
                form_app.reset ();
                form_switchboard.reset ();
                form_wingpanel.reset ();
            });

            form_app.on_validate.connect (() => {
                actions.toggle_primary_action (form_app.is_valid);
            });

            form_app.submit.connect (() => {
                Alcadica.Services.UserSettings settings = new Alcadica.Services.UserSettings ();
                string projectname = form_app.project_name.text;
                string dirpath = form_app.get_full_directory ();
                var service = new Services.Templates.App (dirpath);

                service.root_dir_name = form_app.rdnn_name.text;

                service.add_token ("antispammail", settings.user_email.replace("@", "_AT_"));
                service.add_token ("execname", form_app.rdnn_name.text);
                service.add_token ("issue_tracker_url", string.join ("/", settings.user_github_url, projectname, "issues"));
                service.add_token ("name", settings.user_name);
                service.add_token ("projectname", projectname);
                service.add_token ("site", settings.user_website_url);

                service.on_creation_end.connect (status => {
                    Services.ActionManager.instance.dispatch (Actions.ProjectEditing.TEMPLATE_DID_COPY);
                    this.on_template_creation_end (dirpath);
                });

                service.start ();
            });

            form_switchboard.on_validate.connect (() => {
                actions.toggle_primary_action (form_switchboard.is_valid);
            });

            form_switchboard.submit.connect (() => {
                Alcadica.Services.UserSettings settings = new Alcadica.Services.UserSettings ();
                string dirpath = form_switchboard.get_full_directory ();
                string projectname = form_switchboard.project_name.text;
                var service = new Services.Templates.SwitchboardWidget (dirpath);

                service.root_dir_name = form_switchboard.rdnn_name.text;

                service.add_token ("antispammail", settings.user_email.replace("@", "_AT_"));
                service.add_token ("plugdisplayname", projectname);
                service.add_token ("plugdescription", form_switchboard.plug_description.text);
                service.add_token ("execname", form_switchboard.rdnn_name.text);
                service.add_token ("issue_tracker_url", string.join ("/", settings.user_github_url, projectname, "issues"));
                service.add_token ("name", settings.user_name);
                service.add_token ("plugincategory", form_switchboard.category_name.down ());

                string category_id_enum;

                switch (form_switchboard.category.value) {
                    case Switchboard.Plug.Category.PERSONAL:
                        category_id_enum = "Switchboard.Plug.Category.PERSONAL";
                    break;
                    case Switchboard.Plug.Category.HARDWARE:
                        category_id_enum = "Switchboard.Plug.Category.HARDWARE";
                    break;
                    case Switchboard.Plug.Category.NETWORK:
                        category_id_enum = "Switchboard.Plug.Category.NETWORK";
                    break;
                    case Switchboard.Plug.Category.SYSTEM:
                        category_id_enum = "Switchboard.Plug.Category.SYSTEM";
                    break;
                    case Switchboard.Plug.Category.OTHER:
                        category_id_enum = "Switchboard.Plug.Category.OTHER";
                    break;
                }
                
                service.add_token ("plugincategoryid", category_id_enum);
                service.add_token ("projectname", projectname);
                service.add_token ("site", settings.user_website_url);

                service.on_creation_end.connect (status => {
                    Services.ActionManager.instance.dispatch (Actions.ProjectEditing.TEMPLATE_DID_COPY);
                    this.on_template_creation_end (dirpath);
                });

                service.start ();
            });

            form_wingpanel.on_validate.connect (() => {
                actions.toggle_primary_action (form_wingpanel.is_valid);
            });

            form_wingpanel.submit.connect (() => {
                Alcadica.Services.UserSettings settings = new Alcadica.Services.UserSettings ();
                string projectname = form_wingpanel.project_name.text;
                string dirpath = form_wingpanel.get_full_directory ();
                var service = new Services.Templates.WingpanelWidget (dirpath);

                service.root_dir_name = form_wingpanel.rdnn_name.text;

                service.add_token ("antispammail", settings.user_email.replace("@", "_AT_"));
                service.add_token ("execname", form_wingpanel.rdnn_name.text);
                service.add_token ("issue_tracker_url", string.join ("/", settings.user_github_url, projectname, "issues"));
                service.add_token ("name", settings.user_name);
                service.add_token ("indicatordescription", form_wingpanel.indicator_description.text);
                service.add_token ("projectname", projectname);
                service.add_token ("site", settings.user_website_url);

                service.on_creation_end.connect (status => {
                    Services.ActionManager.instance.dispatch (Actions.ProjectEditing.TEMPLATE_DID_COPY);
                    this.on_template_creation_end (dirpath);
                });

                service.start ();
            });

            actions.primary_action.clicked.connect (() => {
                this.current_form.submit ();
                actions.disable ();
            });

            actions.secondary_action.clicked.connect (() => {
                this.reset ();
                this.on_undo ();
            });
        }

        protected void hide_all_forms () {
            this.form_app.hide ();
            this.form_switchboard.hide ();
            this.form_wingpanel.hide ();
        }

        protected void show_form (Forms.FormBase form) {
            this.current_form.show ();
            this.current_form.focusin ();
        }

        public void reset () {
            this.on_reset ();
        }

        public void show_app_form () {
            this.hide_all_forms ();
            this.current_form = this.form_app;
            this.show_form (this.form_app);
        }

        public void show_form_switchboard () {
            this.hide_all_forms ();
            this.current_form = this.form_switchboard;
            this.show_form (this.form_switchboard);
        }

        public void show_form_wingpanel () {
            this.hide_all_forms ();
            this.current_form = this.form_wingpanel;
            this.show_form (this.form_wingpanel);
        }
    }
}