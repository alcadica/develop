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
using Alcadica.Entities.Template;
using Alcadica.Services;
using Granite.Services;

namespace Alcadica.Services { 
    public abstract class TemplateService : Object { 
        public unowned List<TemplateFile> directories { get; set; }
        public unowned List<TemplateFile> files { get; set; }
        public unowned List<TemplateToken> tokens { get; set; }
        public string base_dir { get; set; }
        public string root_dir_name { get; set; }
        public string template_name { get; set; }

        protected abstract void on_init ();
        protected abstract void on_directory_write_end (TemplateFile file);
        protected abstract void on_file_write_end (TemplateFile file);
        public signal void on_creation_end (bool without_errors);

        public TemplateService(string template_name, string base_dir) {
            this.directories = new List<TemplateFile> ();
            this.files = new List<TemplateFile> ();
            this.base_dir = base_dir;
            this.template_name = template_name;

            this.add_token ("yearrange", new DateTime.now (new TimeZone.local ()).get_year ().to_string () + " - Today");
        }

        protected string get_shared_template_dir () {
            return Path.build_filename ("/", "usr", "share", APP_ID, "templates", this.template_name);
        }

        protected bool create_directories () {
            int count = 0;

            this.directories.foreach (directory => {
                debug ("Creating directory " + directory.path);

                if (FileSystem.mkdir(directory.path)) {
                    this.on_directory_write_end (directory);
                    count += 1;
                }
            });

            return count == this.directories.length ();
        }

        protected bool create_project_root () {
            return FileSystem.mkdir (this.root_dir_name);
        }

        protected bool create_files () {
            int count = 0;

            foreach (TemplateFile file in this.files) {
                string result = file.content;

                foreach (TemplateToken token in this.tokens) {
                    result = result.replace (token.token, token.token_value);
                }

                debug ("Writing file to " + file.path);
                
                if (FileSystem.write_file (file.path, result)) {
                    this.on_file_write_end (file);
                    count += 1;
                }
            }

            return count == this.files.length ();
        }

        protected string get_content_from_shared_file (string filename) {
            return FileSystem.read (Path.build_filename (get_shared_template_dir (), filename));
        }

        public uint add_file (string path, string content = "") {
            TemplateFile directory = new TemplateFile();
            TemplateFile file = new TemplateFile();
            
            directory.path = Path.build_filename (this.base_dir, Path.get_dirname (path));
            file.file_type = TemplateFileType.Directory;

            file.content = content;
            file.path = Path.build_filename (this.base_dir, path);
            file.file_type = TemplateFileType.File;
            
            this.directories.append (directory);
            this.files.append (file);

            return this.files.length ();
        }

        public uint add_token (string token_name, string token_value) {
            this.tokens.append (new TemplateToken (token_name, token_value));
            return this.tokens.length ();
        }

        public bool start () {
            this.on_init ();

            if (this.create_project_root ()) {
                bool directories = this.create_directories ();
                bool files = this.create_files ();
                bool without_errors = directories && files;

                this.on_creation_end (without_errors);
                
                return without_errors;
            }
            
            return false;
        }
    }
}