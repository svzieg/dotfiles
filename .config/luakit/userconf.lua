local settings = require "settings"



-- need hunspell to check language for
luakit.enable_spell_checking = true
luakit.spell_checking_languages = { "de_DE", "en_GB" }

settings.window.home_page = "manjaro.org"

local engines = settings.window.search_engines
engines.aur          = "https://aur.archlinux.org/packages.php?O=0&K=%s&do_Search=Go"
engines.aw           = "https://wiki.archlinux.org/index.php/Special:Search?fulltext=Search&search=%s"

--- If called as :open wikipedia arch linux, this will open the Arch Linux page on the German Wikipedia; with :open wikipedia fr: arch linux, this will use the French Wikipedia instead.
engines.wikipedia = function (arg)
  local l, s = arg:match("^(%a%a):%s*(.+)")
  if l then
    return "https://" .. l .. ".wikipedia.org/wiki/Special:Search?search=" .. s
  else
    return "https://de.wikipedia.org/wiki/Special:Search?search=" .. arg
  end

end


