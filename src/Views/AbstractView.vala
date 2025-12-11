/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2019-2025 elementary Inc. (https://elementary.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 */

public abstract class AbstractView : Gtk.Box {
    protected Gtk.Box button_box;
    protected Gtk.Grid content_area;
    protected Gtk.Image badge;
    protected Gtk.Label primary_label;
    protected Gtk.Label secondary_label;

    construct {
        var image = new Gtk.Image.from_icon_name ("shield") {
            pixel_size = 48,
            valign = Gtk.Align.START
        };

        badge = new Gtk.Image () {
            pixel_size = 24,
            halign = Gtk.Align.END,
            valign = Gtk.Align.END
        };

        var overlay = new Gtk.Overlay () {
            child = image,
            valign = Gtk.Align.START
        };
        overlay.add_overlay (badge);

        primary_label = new Gtk.Label (null) {
            max_width_chars = 1,
            selectable = true,
            wrap = true,
            xalign = 0
        };
        primary_label.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

        secondary_label = new Gtk.Label (null) {
            margin_bottom = 18,
            max_width_chars = 50,
            selectable = true,
            use_markup = true,
            width_chars = 50,
            wrap = true,
            xalign = 0
        };

        content_area = new Gtk.Grid () {
            orientation = Gtk.Orientation.VERTICAL,
            row_spacing = 6
        };

        button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
            homogeneous = true,
            hexpand = true,
            vexpand = true,
            halign = Gtk.Align.END,
            valign = Gtk.Align.END
        };
        button_box.add_css_class ("dialog-action-area");

        var message_grid = new Gtk.Grid () {
            column_spacing = 12,
            row_spacing = 6
        };
        message_grid.attach (overlay, 0, 0, 1, 2);
        message_grid.attach (primary_label, 1, 0);
        message_grid.attach (secondary_label, 1, 1);
        message_grid.attach (content_area, 1, 2);
        message_grid.add_css_class ("dialog-content-area");

        orientation = Gtk.Orientation.VERTICAL;
        append (message_grid);
        append (button_box);
        add_css_class ("dialog-vbox");
    }
}
