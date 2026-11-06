# Quick Eject

[English](#english) · [Русский](#русский)

<a id="english"></a>
## English

Quick Eject is a small macOS menu bar utility for safely ejecting external disks after an explicit confirmation.

### Features

- **Left-click** the menu bar icon to review mounted external volumes and confirm ejection.
- **Right-click** the icon to open the app menu.
- Uses macOS `NSWorkspace` safe unmount and eject API.
- Detects fixed external USB drives as well as removable media.
- Does not run shell commands or require administrator privileges.

### Requirements

- macOS 13 or later.
- Xcode or Xcode Command Line Tools.

### Build

```sh
make build
```

This creates `Quick Eject.app`. To compile only the executable:

```sh
swiftc -O -framework AppKit QuickEject.swift -o QuickEject
```

### Install and launch

Copy `Quick Eject.app` to `/Applications` and open it. To launch at login, add the app under **System Settings → General → Login Items**.

### Safety and privacy

Quick Eject considers mounted, non-internal volumes under `/Volumes`. Before confirming, close files and apps that use the disk. macOS may refuse to eject a volume that is busy; the app reports the result. Cancel leaves all disks mounted.

The app does not erase, format, or write files to disks. It has no network access, telemetry, or background service, and requests no special entitlements.

### License

MIT. See [LICENSE](LICENSE).

---

<a id="русский"></a>
## Русский

Quick Eject — небольшая утилита для строки меню macOS. Она безопасно извлекает внешние диски только после подтверждения пользователя.

### Возможности

- **Левый клик** по значку показывает подключённые внешние тома и запрос подтверждения.
- **Правый клик** открывает меню приложения.
- Для безопасного отключения используется системный API macOS `NSWorkspace`.
- Поддерживаются внешние USB-диски с фиксированным носителем и съёмные носители.
- Приложение не запускает команды оболочки и не требует прав администратора.

### Требования

- macOS 13 или новее.
- Xcode или Xcode Command Line Tools.

### Сборка

```sh
make build
```

Команда создаёт приложение `Quick Eject.app`. Чтобы собрать только исполняемый файл:

```sh
swiftc -O -framework AppKit QuickEject.swift -o QuickEject
```

### Установка и запуск

Скопируйте `Quick Eject.app` в `/Applications` и откройте его. Чтобы приложение запускалось при входе в систему, добавьте его в **Системные настройки → Основные → Объекты входа**.

### Безопасность и конфиденциальность

Quick Eject рассматривает подключённые внешние тома в `/Volumes`. Перед подтверждением закройте файлы и приложения, которые используют диск. Если диск занят, macOS может отказать в извлечении; приложение покажет результат. Кнопка отмены оставляет все диски подключёнными.

Приложение не стирает, не форматирует и не записывает файлы на диски. Оно не использует сеть, телеметрию или фоновую службу и не запрашивает специальных разрешений.

### Лицензия

MIT. См. файл [LICENSE](LICENSE).
