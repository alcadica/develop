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
using Alcadica.Develop.Services.Editor;
using Alcadica.Develop.Plugins.Entities.Common;

namespace Alcadica.Develop.Widgets.Editor {
    public class Assets : Box {
        private Alcadica.Widgets.ActionBar actions;
        private ListBox list_box;
        private List<CheckButton> checkbox_list = new List<CheckButton> ();
        private SourceTreeItem tree_item;
        
        construct {
            var action_box = new Box (Orientation.HORIZONTAL, 0);
            var plugin_context = Services.Editor.PluginContext.context;
            var scrolled_window = new ScrolledWindow (null, null);
            var close_icon = new Button.from_icon_name ("application-exit-symbolic", IconSize.MENU);
            var select_all_icon = new Button.from_icon_name ("selection-checked", IconSize.MENU);
            var header_bar = new HeaderBar ();

            this.actions = new Alcadica.Widgets.ActionBar ();
            this.list_box = new ListBox ();

            close_icon.relief = ReliefStyle.NONE;
            close_icon.tooltip_text = _("Close assets view");
            select_all_icon.relief = ReliefStyle.NONE;
            select_all_icon.tooltip_text = _("Select all assets");
            
            this.actions.primary_action.label = _("Remove selected");
            this.actions.secondary_action.label = _("Deselect all");
            this.actions.disable ();

            action_box.pack_end (this.actions);
            header_bar.title = _("Assets");
            header_bar.pack_end (close_icon);
            header_bar.pack_end (select_all_icon);

            scrolled_window.add (this.list_box);

            orientation = Orientation.VERTICAL;

            this.add (header_bar);
            this.pack_start (scrolled_window);
            this.pack_end (action_box);

            plugin_context.editor.show_assets.connect (show_assets);

            this.actions.primary_action.clicked.connect (() => {
                string title = _("Confirm removal");
                string text = _("You are going to remove these assets permanentely, this action cannot be undone.");

                var window  = new Dialogs.ConfirmRemove (title, text);

                window.on_confirm.connect (() => {
                    var assets = this.get_selected_assets ();
                    tree_item.remove_leaves ();
                    this.empty_assets ();
                });

                window.run ();
            });

            this.actions.secondary_action.clicked.connect (() => {
                foreach (var checkbox in this.checkbox_list) {
                    checkbox.active = false;
                }
            });

            close_icon.clicked.connect (() => {
                Services.ActionManager.instance.dispatch (Actions.Window.SHOW_PREVIOUS_EDITOR_VIEW);
            });

            select_all_icon.clicked.connect (() => {
                foreach (var item in this.checkbox_list) {
                    item.active = true;
                }
            });
        }

        private ListBoxRow create_asset_row (string label) {
            ListBoxRow element = new ListBoxRow ();
            CheckButton element_selectable = new CheckButton.with_label (label);

            element_selectable.toggled.connect (() => {
                if (this.get_selected_checkboxes ().length () > 0) {
                    this.actions.enable ();
                } else {
                    this.actions.disable ();
                }
            });

            element.activatable = true;
            element.selectable = true;
            element.add (element_selectable);
            
            this.checkbox_list.append (element_selectable);

            return element;
        }

        private void empty_assets () {
            this.actions.disable ();
            
            foreach (var checkbox in this.checkbox_list) {
                this.checkbox_list.remove (checkbox);    
            }
            
            foreach (var child in list_box.get_children ()) {
                child.dispose ();
            }   
        }

        private List<string> get_selected_assets () {
            List<string> result = new List<string> ();

            foreach (var checkbox in this.get_selected_checkboxes ()) {
                result.append (checkbox.label);
            }

            return result;
        }

        private List<CheckButton> get_selected_checkboxes () {
            List<CheckButton> result = new List<CheckButton> ();

            foreach (var checkbox in this.checkbox_list) {
                if (checkbox.active) {
                    result.append (checkbox);
                }
            }

            return result;
        }

        private void show_assets (string assets_title, List<string> assets, SourceTreeItem tree_item) {
            this.empty_assets ();
            this.tree_item = tree_item;
            
            foreach (var asset in assets) {
                var element = this.create_asset_row (asset);
                
                list_box.add (element);
            }

            list_box.show_all ();

            Services.ActionManager.instance.dispatch (Actions.Window.SHOW_ASSETS_MANAGER);
        }
    }
}