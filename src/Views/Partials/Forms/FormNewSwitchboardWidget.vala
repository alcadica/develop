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
    public class FormNewSwitchboardWidget : FormBase {
        //  public Switchboard.Plug.Category category { get; set; }
        public Button select_directory { get; set; }
        public EntryWithLabel project_name { get; set; }
        public ComboBoxWithLabel category { get; set; }
        public EntryWithLabel rdnn_name { get; set; }
        public EntryWithLabel plug_description { get; set; }
        public HeaderLabel form_title { get; set; }
        public string project_directory { get; set; }
        public string category_name {
            get {
                var option = this.category.get_option_by_value (this.category.value);

                if (option == null) {
                    return "";
                }

                return option.value;
            }
        }

        construct {
            var select_directory_text = _("Choose project folder");
            var settings = new Services.UserSettings ();
            string rdnn = new Services.RDNN (settings.user_github_url).to_string ();

            this.category = new ComboBoxWithLabel (_("Switchboard category"));
            this.form_title = new HeaderLabel (_("Create a new Switchboard Plug"));
            this.project_name = new EntryWithLabel (_("Plug name"));
            this.plug_description = new EntryWithLabel (_("Plug description"));
            this.rdnn_name = new EntryWithLabel (_("RDNN name"));
            this.select_directory = new Button.with_label (select_directory_text);

            this.project_directory = "";

            this.category.add_option (Switchboard.Plug.Category.PERSONAL, _("Personal"));
            this.category.add_option (Switchboard.Plug.Category.HARDWARE, _("Hardware"));
            this.category.add_option (Switchboard.Plug.Category.NETWORK, _("Network"));
            this.category.add_option (Switchboard.Plug.Category.SYSTEM, _("System"));
            this.category.add_option (Switchboard.Plug.Category.OTHER, _("Other"));
            this.category.value = Switchboard.Plug.Category.PERSONAL;

            this.add (this.form_title);
            this.add (this.project_name);
            this.add (this.plug_description);
            this.add (this.category);
            this.add (this.rdnn_name);
            this.add (this.select_directory);

            this.rdnn_name.entry.text = rdnn;
            this.project_name.pattern = Alcadica.CommonRegEx.PROJECT_NAME;

            this.select_directory.clicked.connect (() => {
                this.project_directory = Services.FileSystem.choose_directory (select_directory_text);
                this.validate ();
            });

            this.project_name.changed.connect (() => {
                this.validate ();
                if (project_name.text != "") {
                    rdnn_name.entry.text = rdnn + "." + project_name.text;
                } else {
                    rdnn_name.entry.text = rdnn;
                }
            });

            focusin.connect (() => {
                project_name.focusin ();
            });
        }

        public string get_full_directory () {
            return Path.build_filename (project_directory, rdnn_name.entry.text);
        }

        public override void reset () {
            is_valid = false;
            rdnn_name.entry.text = "";
            project_name.text = "";
            project_directory = "";
        }

        public override void validate () {
            this.is_valid = this.project_name.valid && this.project_directory != "";
            this.on_validate ();
        }
    }
}
