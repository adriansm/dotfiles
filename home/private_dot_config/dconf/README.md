# Plain text configuration dump for GNOME/gsettings

GNOME settings are not really stored in plain text, they are stored wih special
dconf program and translated into internal hash-table of sorts. However, to
keep these under version control, keeping track of the settings here and
dumping them into dconf during install script.

# Obtaining plain text configuration
The following command can be used to write out the dconf database into plain
text:
```
dconf dump /
```

This holds too much data though, it's better to selectively add the
configurations that we care about, you can modify configurations on the fly and
see which sections are changing:
```
dconf watch /
```

# Restoring plain text configurations
Afterward look for interesting sections and dump them into separate files in
the user.d folder. These can then easily be loaded when they are changed:
```
cat ~/.config/dconf/user.d/* | dconf load /
```



