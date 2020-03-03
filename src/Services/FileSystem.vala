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
    public class FileSystem : GLib.Object {

        public static ApplicationWindow window { get; set; }

        public static bool claim (string filepath) {
            File file = File.new_for_path (filepath);

            try {
                file.create (FileCreateFlags.NONE, null);
                return true;
            } catch (Error _error) {
                return false;
            }
        }

        public static string choose_directory (string title) {
            return FileSystem.choose_directories (title).nth_data (0);
        }

        public static List<string> choose_directories (string title) {
            List<string> list = new List<string> ();

            Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
                title,
                FileSystem.window,
                FileChooserAction.SELECT_FOLDER,
                        "_Cancel",
                        Gtk.ResponseType.CANCEL,
                        "_Open",
                Gtk.ResponseType.ACCEPT
            );

            Gtk.FileFilter filter = new Gtk.FileFilter ();

            filter.add_mime_type ("inode/directory");

            chooser.set_filter (filter);

            if (chooser.run () == Gtk.ResponseType.ACCEPT) {
                SList<string> names = chooser.get_filenames ();

                foreach (unowned string name in names) {
                list.append (name);
                }
            }

            chooser.close ();

            return list;
        }

        public static bool dir_exists (string path) {
            var file = File.new_for_path (path);

            if (file.query_exists ()) {
                return file.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS, null) == FileType.DIRECTORY;
            }

            return false;
        }

        public static bool file_exists (string path) {
            var file = File.new_for_path (path);

            if (file.query_exists ()) {
                switch (file.query_file_type (0)) {
                    case FileType.MOUNTABLE:
                    case FileType.REGULAR:
                    case FileType.SHORTCUT:
                    case FileType.SPECIAL:
                    case FileType.SYMBOLIC_LINK:
                    case FileType.UNKNOWN:
                        return true;
                    default:
                        return false;
                }
            }

            return false;
        }

        public static bool mkdir (string path) {
            if (dir_exists (path)) {
                return false;
            }
            try {
                File.new_for_path (path).make_directory_with_parents ();
                return dir_exists (path);
            } catch (Error error) {
                warning ("mkdir: " + error.message + "\n path=" + path);
                return false;
            }
        }

        public static string read (string path) {
            File file = File.new_for_path (path);

            try {
                FileInputStream @is = file.read ();
                DataInputStream dis = new DataInputStream (@is);
                string content = "";
                string line;

                while ((line = dis.read_line ()) != null) {
                    content += line + "\n";
                }

                return content;
            } catch (Error error) {
                warning ("Cannot read file " + path + " because of " + error.message);
                return "";
            }
        }

        public static bool rename (File file, string filename, FileCopyFlags flags = FileCopyFlags.NONE) {
            string? path = file.get_path ();

            if (path == null || path == "") {
                return false;
            }

            File newfile = File.new_for_path (path.replace (file.get_basename (), filename));

            try {
                return file.move (newfile, flags);
            } catch (Error error) {
                warning ("[File: " + path + "] " + error.message);
                return false;
            }
        }

        public static bool write_file (string path, string content) {
            if (file_exists (path)) {
                return false;
            }

            try {
                File file = File.new_for_path (path);
                var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));

                uint8[] data = content.data;
                long written = 0;
                while (written < data.length) {
                    written += dos.write (data[written:data.length]);
                }
                return true;
            } catch (Error error) {
                warning ("write_file: " + error.message + "\n path=" + path + "\n content=" + content);
                return false;
            }
        }
    }
}
