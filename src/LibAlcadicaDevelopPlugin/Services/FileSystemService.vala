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
namespace Alcadica.Develop.Plugins.Services { 
	public class FileSystemService {
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
		
		public static bool is_directory (File file) {
			return file.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS) == FileType.DIRECTORY;
		}

		public static bool is_file (File file) {
			return file.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS) == FileType.REGULAR;
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

		public static List<string> read_dir_recursive (File file) {
			List<string> result = new List <string> ();

			if (is_file (file)) {
				result.append (file.get_path ());
				return result;
			}

			try {
				var enumerator = file.enumerate_children (FileAttribute.STANDARD_NAME, 0);

				FileInfo file_info;

				while ((file_info = enumerator.next_file ()) != null) {
					string _path = Path.build_filename (file.get_path (), file_info.get_name ());
					List<string> results = read_dir_recursive (File.new_for_path (_path));
					
					foreach (var filepath in results) {
						result.append (filepath);
					}
				}
			} catch (Error _error) {
				warning (_error.message);
			}

			return result;
		}

        public static string read_file_content (string path) {
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
		
		public static File replace_file_content (File file, string content) {
			if (!is_file (file)) {
				return file;
			}
			
			try {
				file.replace_contents (content.data, null, false, FileCreateFlags.NONE, null);
			} catch (Error _error) {
				warning (_error.message);
			}

			return file;
		}		
		
		public static bool write (File file) {
			string path = file.get_path ();
			return write_file (path, read_file_content (path));
		}

		public static bool write_file (string path, string content) {
			string basename = Path.get_basename (path);
			File file = File.new_for_path (path);
			
			debug ("Writing file " + basename);

			if (is_file (file)) {
                return false;
            }
            
            try {
                File directories = File.new_for_path (Path.get_dirname (path));
                
                if (!directories.query_exists ()) {
                    directories.make_directory_with_parents ();
                }
                
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