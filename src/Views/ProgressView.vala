/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2019-2025 elementary Inc. (https://elementary.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 */

public class Unboxing.ProgressView : AbstractView {

    private Gtk.ProgressBar progressbar;

    public string app_name {
        set {
            primary_label.label = _("Installing “%s”").printf (value);
        }
    }

    public double progress {
        set {
            progressbar.fraction = value;
        }
    }

    public string status {
        set {
            secondary_label.label = "<span font-features='tnum'>%s</span>".printf (value);
        }
    }

    construct {
        secondary_label.use_markup = true;
        secondary_label.label = _("Preparing…");

        progressbar = new Gtk.ProgressBar () {
            pulse_step = 0.05,
            fraction = 0.0,
            hexpand = true
        };

        Timeout.add (50, () => { progressbar.pulse (); } );

        content_area.attach (progressbar, 0, 0);

        var cancel_button = new Gtk.Button.with_label (_("Cancel")) {
            action_name = "app.quit"
        };

        button_box.append (cancel_button);
    }
}
