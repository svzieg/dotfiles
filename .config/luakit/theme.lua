
--------------------------
-- Default luakit theme --
--------------------------



local theme = {}

-- Default settings
theme.font = "Fire Code Regular 14"
theme.fg   = "#eceff4"
theme.bg   = "#2e3440"

-- Genaral colours
theme.success_fg = "#a3be8c"
theme.loaded_fg  = "#5e81ac"
theme.error_fg = "#FFF"
theme.error_bg = "#bf616a"

-- Warning colours
theme.warning_fg = "#ebcb8b"
theme.warning_bg = "#FFF"

-- Notification colours
theme.notif_fg = "#e5e9f0"
theme.notif_bg = "#434c5e"

-- Menu colours
theme.menu_fg                   = "#e5e9f0"
theme.menu_bg                   = "#2e3440"
theme.menu_selected_fg          = "#eceff4"
theme.menu_selected_bg          = "#434c5e"
theme.menu_title_bg             = "#4c566a"
theme.menu_primary_title_fg     = "#434c5e"
theme.menu_secondary_title_fg   = "#3b4252"

-- Proxy manager
theme.proxy_active_menu_fg      = '#000'
theme.proxy_active_menu_bg      = '#FFF'
theme.proxy_inactive_menu_fg    = '#888'
theme.proxy_inactive_menu_bg    = '#FFF'

-- Statusbar specific
theme.sbar_fg         = "#eceff4"
theme.sbar_bg         = "#2e3440"

-- Downloadbar specific
theme.dbar_fg         = "#eceff4"
theme.dbar_bg         = "#2e3440"
theme.dbar_error_fg   = "#bf616a"

-- Input bar specific
theme.ibar_fg           = "#eceff4"
theme.ibar_bg           = "#2e3440"

-- Tab label
theme.tab_fg            = "#eceff4"
theme.tab_bg            = "#2e3440"
theme.tab_ntheme        = "#70058b"
theme.selected_fg       = "#88c0d0"
theme.selected_bg       = "#434c5e"
theme.selected_ntheme   = "#5e81ac"
theme.loading_fg        = "#8fbcbb"
theme.loading_bg        = "#2e3440"

-- Trusted/untrusted ssl colours
theme.trust_fg          = "#0F0"
theme.notrust_fg        = "#F00"



theme.success_fg = "#a3be8c"
theme.loaded_fg  = "#5e81ac"
theme.error_fg = "#FFF"
theme.error_bg = "#bf616a"

-- General colour pairings
theme.ok = { fg = "#FFF", bg = "#a3be8c" }
theme.warn = { fg = "#FFF", bg = "#ebcb8b" }
theme.error = { fg = "#FFF", bg = "#bf616a" }

return theme
-- vim: et:sw=4:ts=8:sts=4:tw=80
