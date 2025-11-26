/*
* Copyright 2019-2022 elementary, Inc. (https://elementary.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
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
*/

public class Unboxing.Application : Gtk.Application {

    private Cancellable cancellable;

    public Application () {
        GLib.Intl.setlocale (LocaleCategory.ALL, "");
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        GLib.Intl.textdomain (GETTEXT_PACKAGE);

        Object (
            application_id: "io.github.teamcons.unboxing",
            flags: ApplicationFlags.HANDLES_OPEN
        );
    }

    protected void old_open (File[] files, string hint) {
        if (files.length == 0) {
            return;
        }

        var file = files[0];
        if (get_windows ().length () > 0) {
            get_windows ().data.present ();
            return;
        }

        hold ();
        open_file.begin (file);
    }

    private async void open_file (File file) {
        unboxing.MainWindow main_window = null;

        main_window = new MainWindow (this, file);
        main_window.present ();

        var launch_action = new SimpleAction ("launch", null);

        add_action (launch_action);

        launch_action.activate.connect (() => {
            main_window.flatpak_file.launch.begin ((obj, res) => {
                main_window.flatpak_file.launch.end (res);
                main_window.close ();
            });
        });

        release ();
    }

    protected override void startup () {
        base.startup ();
        Granite.init ();

        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == DARK;
        });

        var quit_action = new SimpleAction ("quit", null);

        add_action (quit_action);

        set_accels_for_action ("app.quit", {"<Control>q"});

        quit_action.activate.connect (quit);
    }

    protected override void activate () {

    }

    public string get_appstore_name () {
        var appinfo = GLib.AppInfo.get_default_for_uri_scheme ("appstream");
        if (appinfo != null) {
            return appinfo.get_name ();
        } else {
            return _("your software center");
        }
    }

    public static int main (string[] args) {
        if (args.length < 2) {
            print ("Usage: %s /path/to/flatpakref or /path/to/flatpak\n", args[0]);
            return 1;
        }

        var app = new Application ();
        return app.run (args);
    }







    protected override void open (File[] files, string hint) {
        
        this.hold();
        var flags = Pk.Bitfield.from_enums (Pk.TransactionFlag.ALLOW_DOWNGRADE, Pk.TransactionFlag.ALLOW_REINSTALL, Pk.TransactionFlag.SIMULATE);

        string[] filelist = {};
        foreach (var file in files) {
            filelist += file.get_path ();
            print (file.get_path ());
        }

        var task = new Pk.Task ();
        cancellable = new Cancellable ();

        task.install_files_async.begin (
                filelist,
                cancellable,
                progress_cb,
                async_cb);
    }

    public void progress_cb (Pk.Progress progress, Pk.ProgressType type) {
        print ("\n" + Unboxing.status_to_title (progress.status) + "|");
        print ("ROLE: " + progress.get_role ().to_localised_present () + " | ");
        print ("PERCENT: " + progress.percentage.to_string () + " | ");
    }

    // Delegate
    public void async_cb(Object? object, AsyncResult res)
    {
        print ("cb called");
        var task = object as Pk.Task;
        assert_nonnull(task);

    
        try
        {
            var result = task.install_files_async.end(res);
            print (result.role.to_localised_present () + "\n");
            print (result.get_exit_code ().to_string () + "\n");
            print ("finished lol");


        }
        catch (Error e)
        {
            print (e.message);
        }
    }


}
