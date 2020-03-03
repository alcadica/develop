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

namespace Alcadica.Services {
    public class RDNN : GLib.Object {
        protected string[] chunks { get; set; }
        protected string domain { get; set; }

        public RDNN (string domain) {
            string _domain = domain
                .replace ("http://", "")
                .replace ("https://", "")
                .replace ("www.", "")
            ;

            _domain = _domain.strip ();

            string[] _domain_chunks = _domain.split ("/");
            string[] _chunks_sorted = {};

            string first_part = _domain_chunks [0];
            string second_part = _domain_chunks [1];
            string[] first_part_chunks = first_part.split (".");
            string[] second_part_chunks = second_part.split ("/");

            for (int i = first_part_chunks.length; i > 0; i--) {
                _chunks_sorted += first_part_chunks[i - 1];
            }

            for (int i = 0; i < second_part_chunks.length; i++) {
                _chunks_sorted += second_part_chunks[i];
            }

            this.domain = domain;
            this.chunks = _chunks_sorted;
        }

        public static bool is_valid_name (string name) {
            try {
                Regex checker = new Regex ("^[A-Za-z]{2,6}((?!-)\\.[A-Za-z0-9-]{1,63}(?<!-))+$");
                return checker.match (name);
            } catch (Error error) {
                warning (error.message);
                return false;
            }
        }

        protected string sanitize (string input) {
            string result;

            if (input.length == 0) {
                return "";
            }

            try {
                Regex sanitizer = new Regex ("\\s+$");
                result = sanitizer.replace (input.strip (), input.length, 0, "-").replace ("/", ".");
            } catch (Error error) {
                result = "";
                critical (error.message);
            }

            return result;
        }

        public string to_string () {
            string[] sanitized_chunks = {};

            foreach (var chunk in this.chunks) {
                sanitized_chunks += this.sanitize (chunk);
            }

            return string.joinv (".", sanitized_chunks).down ();
        }
    }
}
