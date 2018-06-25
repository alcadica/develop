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
namespace Alcadica.Develop.Views.Partials.Editor { 
	public class CodeEditor : Gtk.Box {
		construct {
			var editor_context = Develop.Services.Editor.PluginContext.context.editor;
			var source_view = new Gtk.SourceView ();
			var dynamic_notebook = new Granite.Widgets.DynamicNotebook ();

			this.add (dynamic_notebook);
			this.pack_end (source_view);

			this.orientation = Gtk.Orientation.VERTICAL;

			dynamic_notebook.force_left = true;
			dynamic_notebook.tabs_closable = true;

			editor_context.open_editors.on_list_change.connect (() => {
				var editor = editor_context.open_editors.editors.nth_data (editor_context.open_editors.editors.length () - 1);
				var tab = new Widgets.Editor.EditorTab ();
				
				tab.editor = editor;
				tab.label = Path.get_basename (editor.filename);

				dynamic_notebook.insert_tab (tab, dynamic_notebook.n_tabs + 1);

				editor.did_open ();
			});

			dynamic_notebook.tab_removed.connect (tab => {
				Plugins.Entities.Editor.Editor editor = ((Widgets.Editor.EditorTab) tab).editor;
				editor_context.open_editors.remove (editor);
				editor.did_close ();
			});
			
			source_view.focus_in_event.connect (() => {
				editor_context.did_focus ();
			});
		}
	}
}