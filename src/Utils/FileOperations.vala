/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2019-2025 elementary Inc. (https://elementary.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 */

namespace Unboxing.Utils {

    public static unowned void trash_files (File[] files) {
        foreach (var f in files) {
            f.trash_async.begin (GLib.Priority.DEFAULT, null, (obj, res) => {
                try {
                    f.trash_async.end (res);
                } catch (Error e) {
                    warning (e.message);
                }
            });
        }
    }

    public static File tmp_file () {
        var dir = File.new_for_path (Environment.get_user_cache_dir ());

        try {
			if (!dir.query_exists ()) {
				dir.make_directory ();
                print ("created");
			}
		} catch (Error e) {
			warning ("[STORAGE] Failed to prepare target data directory %s\n", e.message);
		}

        var tmp = File.new_for_path (Environment.get_user_cache_dir () + "/" + "Package");
        return tmp;
    }

    public static string[]? loop_files (File[] files) {

        string[] filelist = {};

        foreach (var file in files) {
            if (is_package (file)) {
                filelist += file.get_path ();
            }
        }

        return filelist;
    }

    public static bool is_package (File file) {
        FileInfo info;

        try {
            info = file.query_info (GLib.FileAttribute.STANDARD_CONTENT_TYPE, FileQueryInfoFlags.NONE);

        } catch (Error e) {
            warning (e.message);
            return false;
        }

        var mimetype = info.get_content_type ();

        if (mimetype == null) {
            warning ("Failed to get content type");
            return false;
        }

        return mimetype in Application.SUPPORTED_CONTENT_TYPES;
    }
}
