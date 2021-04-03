#
# Avoiding flake8 errors
# If you use an editor with flake8 and pylint integration,
# it may have some complaints about invalid names, undefined variables,
# or missing docstrings. You can silence those with:
# pylint: disable=C0111
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401

config = config  # type: ConfigAPI # noqa: F821 pylint: disable=E0602,C0103
c = c  # type: ConfigContainer # noqa: F821 pylint: disable=E0602,C0103


#
# Reload Autoconfig
# Since it's not loaded if config.py exists
#
config.load_autoconfig()

#
# Override Autoconfig below
#
c.editor.command = ["alacritty", "-e", "nvim", "-f", "{file}"]


# Tab Settings
c.tabs.position = "top"
c.tabs.show = "multiple"


# Completion Settings
c.completion.shrink = True

c.spellcheck.languages = ["en-US", "de-DE"]


# Key Bindings
config.bind("<Ctrl-,>", "spawn --userscript qute-bitwarden")
config.bind("<Ctrl-e>", "edit-url")


config.bind(
    "xx", "config-cycle statusbar.hide ;; config-cycle tabs.show always switching"
)
config.bind("xt", "config-cycle tabs.show always switching")
config.bind("xb", "config-cycle statusbar.hide")


config.source("themes/nord.py")
