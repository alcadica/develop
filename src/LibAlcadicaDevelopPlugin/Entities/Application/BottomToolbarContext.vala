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
namespace Alcadica.Develop.Plugins.Entities.Application {
	public enum BottomToolbarContextStatus {
		Error,
		Idle,
		Loading,
		RunningTask
	}
	
	public class BottomToolbarContext {
		private BottomToolbarContextStatus _state = BottomToolbarContextStatus.Loading;

		public BottomToolbarContextStatus state {
			get {
				return _state;
			}
			set {
				this.state_will_change (_state, value);
				this._state = value;
				this.state_did_change (_state);
			}
		}
		
		public signal void state_did_change (BottomToolbarContextStatus state);
		public signal void state_will_change (BottomToolbarContextStatus previous_state, BottomToolbarContextStatus next_state);
	}
}