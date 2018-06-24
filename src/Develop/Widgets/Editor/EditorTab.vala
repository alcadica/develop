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
using Alcadica.Develop.Plugins.Entities;
using Alcadica.Develop.Plugins.Entities.Application;

namespace Alcadica.Widgets.Editor {
	public class EditorTab : Granite.Widgets.Tab {
		public Develop.Plugins.Entities.Editor.Editor editor { get; set; }
		
		construct {
			this.pinnable = false;
			this.pinned = false;
		}
	}
}