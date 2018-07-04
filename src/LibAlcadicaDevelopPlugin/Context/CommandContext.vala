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
	public class CommandContext : Object {
		public unowned List<Command.Command> commands { get; private set; }

		public CommandContext () {
			this.commands = new List<Command.Command> ();
		}

		public void add (Command.Command command) {
			if (this.is_set (command)) {
				return;
			}

			this.commands.append (command);
		}

		public void dispatch (Command.Command command) {
			command.activate ();
		}

		public void dispatch_by_name (string command_name) {
			Command.Command? command = this.get_by_name (command_name);

			if (command != null) {
				this.dispatch (command);
			}
		}

		public Command.Command? get_by_name (string command_name) {
			Command.Command? command = null;

			for (int i = 0; i < this.commands.length (); i++) {
				if (this.commands.nth_data (i). command_name == command_name) {
					command = this.commands.nth_data (i);
					break;
				}
			}

			return command;
		}

		public Command.Command? get_by_shortcut (string shortcut) {
			Command.Command? command = null;

			for (int i = 0; i < this.commands.length (); i++) {
				if (this.commands.nth_data (i). shortcut == shortcut) {
					command = this.commands.nth_data (i);
					break;
				}
			}

			return command;
		}
		
		public bool is_set (Command.Command command) {
			return this.commands.find (command).length () > 0;
		}

		public bool is_set_shortcut (string shortcut) {
			return this.get_by_shortcut (shortcut) != null;
		}

		public bool remove (Command.Command command) {
			if (!this.is_set (command)) {
				return false;
			}

			uint initial_length = this.commands.length ();

			this.commands.remove (command);

			return this.commands.length () == initial_length;
		}
	}
}