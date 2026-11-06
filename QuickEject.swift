import AppKit
import Foundation

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "eject.fill", accessibilityDescription: "Отключить внешние диски")
            button.toolTip = "Левый клик: отключить диски · правый клик: меню"
            button.target = self
            button.action = #selector(statusItemClicked(_:))
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Отключить внешние диски…", action: #selector(confirmEject), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Выйти", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = nil
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        self.contextMenu = menu
    }

    private var contextMenu: NSMenu?

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
