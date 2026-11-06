# Quick Eject

A tiny macOS menu bar utility for safely ejecting external volumes after an explicit confirmation.

## Features

- Left-click the menu bar icon to review connected external volumes and confirm ejection.
- Right-click the icon to open the menu.
- Uses macOS `NSWorkspace` safe unmount/eject API.
- Detects fixed external USB drives as well as removable media.
- Does not run shell commands or require administrator privileges.

## Requirements

- macOS 13 or later (built with Swift and AppKit; tested with Xcode 26 SDK).
- Xcode Command Line Tools or Xcode for building from source.

## Build

```sh
swiftc -O -framework AppKit QuickEject.swift -o QuickEject
```

To create a runnable app bundle, place the executable at `Quick Eject.app/Contents/MacOS/QuickEject` and copy `Info.plist` to `Quick Eject.app/Contents/Info.plist`.

## Install and launch

Copy `Quick Eject.app` to `/Applications`, then open it. To launch it at login, add it under **System Settings → General → Login Items**.

## Use

- **Left-click:** show the confirmation dialog. It lists the external volumes that will be ejected.
- **Right-click:** open the menu.
- Choose **Eject** in the confirmation dialog to ask macOS to unmount and eject the listed volumes.

Close files and applications using an external drive before confirming. If macOS cannot safely eject a volume, the result dialog reports the error. Cancel leaves all disks mounted.

## Scope and privacy

Quick Eject only considers mounted, non-internal volumes under `/Volumes`. It does not erase, format, or write files to disks. It has no network access, telemetry, or background service. The app requests no special entitlements.

## License

MIT. See [LICENSE](LICENSE).
