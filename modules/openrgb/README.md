# OpenRGB

OpenRGB starts in the Plasma system tray. Its native **Profiles** menu loads
saved lighting profiles; **Lights Off** switches the lights off.

The popup-only visibility setting targets the current tray containment
(`Containments/2/Applets/7`). If the panel is recreated, update this path from
`~/.config/plasma-org.kde.plasma.desktop-appletsrc`.

`profiles/Lights on.orp` is a snapshot of the saved lighting profile. Home Manager
copies it into `~/.config/OpenRGB/` only when missing, keeping it writable and
preserving subsequent changes made in OpenRGB.

After editing the profile, refresh the repository snapshot with:

```sh
cp ~/.config/OpenRGB/'Lights on.orp' modules/openrgb/profiles/
```

Run this command from the repository root. New profiles also need a corresponding
copy step in `default.nix` to restore them on a fresh installation.
