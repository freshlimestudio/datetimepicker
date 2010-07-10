require 'fileutils'
# Uninstall hook code here

public_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "public"))

[ "ui-bg_diagonals-thick_18_b81900_40x40.png",
  "ui-bg_diagonals-thick_20_666666_40x40.png",
  "ui-bg_flat_10_000000_40x100.png",
  "ui-bg_glass_100_f6f6f6_1x400.png",
  "ui-bg_glass_100_fdf5ce_1x400.png",
  "ui-bg_glass_65_ffffff_1x400.png",
  "ui-bg_gloss-wave_35_f6a828_500x100.png",
  "ui-bg_highlight-soft_100_eeeeee_1x100.png",
  "ui-bg_highlight-soft_75_ffe45c_1x100.png",
  "ui-icons_222222_256x240.png",
  "ui-icons_228ef1_256x240.png",
  "ui-icons_ef8c08_256x240.png",
  "ui-icons_ffd27a_256x240.png",
  "ui-icons_ffffff_256x240.png" ].each { |file| FileUtils.rm(File.join(public_dir, "images", file)) }

[ "jquery.ui.datepicker.js",
  "jquery.ui.datepicker-ru.js",
  "jquery.ui.datepicker-uk.js",
  "jquery-ui-timepicker-addon.js",
  "jquery-ui-timepicker-addon.min.js" ].each { |file| FileUtils.rm(File.join(public_dir, "javascripts", file)) }

[ "jquery-ui-1.8.custom.css" ].each { |file| FileUtils.rm(File.join(public_dir, "stylesheets", file)) }
