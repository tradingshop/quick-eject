import AppKit
import Foundation

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.imagePosition = .imageOnly
            button.imageScaling = .scaleProportionallyUpOrDown
            button.toolTip = "Левый клик: отключить диски · правый клик: меню"
            button.target = self
            button.action = #selector(statusItemClicked(_:))
        }
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(volumesDidChange(_:)), name: NSWorkspace.didMountNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(volumesDidChange(_:)), name: NSWorkspace.didUnmountNotification, object: nil)
        refreshIcon()

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Отключить внешние диски…", action: #selector(confirmEject), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Выйти", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = nil
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        self.contextMenu = menu
    }

    private var contextMenu: NSMenu?

    @objc private func volumesDidChange(_ notification: Notification) {
        refreshIcon()
    }

    private func refreshIcon() {
        let disks = externalVolumes()
        guard let button = statusItem.button else { return }
        let hasExternalDisks = !disks.isEmpty
        let accessibilityDescription = hasExternalDisks ? "Подключены внешние диски" : "Внешних дисков нет"
        let glyphColor = hasExternalDisks
            ? NSColor(calibratedRed: 1.0, green: 0.68, blue: 0.20, alpha: 1.0)
            : NSColor(calibratedRed: 0.83, green: 0.86, blue: 0.90, alpha: 1.0)
        let icon = NSImage(size: NSSize(width: 22, height: 22), flipped: false) { rect in
            let background = NSBezierPath(roundedRect: NSRect(x: 1.0, y: 1.0, width: 20, height: 20), xRadius: 5, yRadius: 5)
            NSColor(calibratedRed: 0.20, green: 0.22, blue: 0.25, alpha: 1.0).setFill()
            background.fill()

            let triangle = NSBezierPath()
            triangle.move(to: NSPoint(x: 11, y: 17))
            triangle.line(to: NSPoint(x: 4.2, y: 8.2))
            triangle.line(to: NSPoint(x: 17.8, y: 8.2))
            triangle.close()
            glyphColor.setFill()
            triangle.fill()

            let bar = NSBezierPath(roundedRect: NSRect(x: 4.0, y: 4.0, width: 14.0, height: 2.5), xRadius: 1.0, yRadius: 1.0)
            glyphColor.setFill()
            bar.fill()
            return true
        }
        icon.accessibilityDescription = accessibilityDescription
        button.image = icon
        button.contentTintColor = nil
        button.toolTip = hasExternalDisks
            ? "Подключено внешних дисков: \(disks.count) · Левый клик: отключить · правый: меню"
            : "Внешних дисков нет · Левый клик: отключить · правый: меню"
    }

    @objc private func statusItemClicked(_ sender: Any?) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp || event.modifierFlags.contains(.control) {
            contextMenu?.popUp(positioning: nil, at: NSPoint(x: 0, y: statusItem.button?.bounds.maxY ?? 0), in: statusItem.button)
        } else {
            confirmEject()
        }
    }

    @objc private func confirmEject() {
        let disks = externalVolumes()
        guard !disks.isEmpty else {
            showAlert(title: "Внешние диски не найдены", message: "Сейчас нет подключённых внешних дисков для отключения.")
            return
        }
        let names = disks.map { "• \($0.lastPathComponent)" }.joined(separator: "\n")
        let alert = NSAlert()
        alert.messageText = "Отключить внешние диски?"
        alert.informativeText = "Сначала убедитесь, что файлы на них закрыты. Будут безопасно извлечены:\n\n\(names)"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Отключить")
        alert.addButton(withTitle: "Отмена")
        guard alert.runModal() == .alertFirstButtonReturn else { return }
        eject(disks)
    }

    private func externalVolumes() -> [URL] {
        let keys: [URLResourceKey] = [.volumeIsRemovableKey, .volumeIsEjectableKey, .volumeIsInternalKey]
        let mounted = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: keys, options: [.skipHiddenVolumes]) ?? []
        return mounted.filter { url in
            let values = try? url.resourceValues(forKeys: Set(keys))
            return url.path.hasPrefix("/Volumes/") && values?.volumeIsInternal == false
        }
    }

    private func eject(_ disks: [URL]) {
        var outcomes: [String] = []
        for disk in disks {
            do {
                try NSWorkspace.shared.unmountAndEjectDevice(at: disk)
                outcomes.append("Отключён: \(disk.lastPathComponent)")
            } catch {
                outcomes.append("Не удалось отключить \(disk.lastPathComponent): \(error.localizedDescription)")
            }
        }
        refreshIcon()
        showAlert(title: "Готово", message: outcomes.joined(separator: "\n"))
    }

    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @objc private func quit() { NSApp.terminate(nil) }
}

let appDelegate = AppDelegate()
NSApplication.shared.delegate = appDelegate
NSApplication.shared.run()
