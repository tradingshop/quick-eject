# Quick Eject

[English](#english) · [Русский](#русский)

<a id="english"></a>
## English

<p align="center">
  <img src="docs/images/menu-bar-connected.svg" width="128" height="128" alt="Square Quick Eject icon with amber eject symbol when an external disk is connected">
  <img src="docs/images/menu-bar-disconnected.svg" width="128" height="128" alt="Square Quick Eject icon with light gray eject symbol when no external disks are connected">
</p>

Quick Eject is a small macOS menu bar utility for safely ejecting external disks after an explicit confirmation.

### Features

- **Left-click** the menu bar icon to review mounted external volumes and confirm ejection.
- **Right-click** the icon to open the app menu.
- The icon is square with a dark rounded background for visibility. Its eject mark is amber when external disks are mounted and light gray when none are connected; it updates when disks are mounted or ejected.
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

### Download, install, and launch

[Download the compiled macOS app](https://github.com/tradingshop/quick-eject/raw/refs/heads/main/dist/Quick-Eject-macOS.zip) and unzip it. Copy `Quick Eject.app` to `/Applications` and open it. To launch at login, add the app under **System Settings → General → Login Items**.

### Safety and privacy

Quick Eject considers mounted, non-internal volumes under `/Volumes`. Before confirming, close files and apps that use the disk. macOS may refuse to eject a volume that is busy; the app reports the result. Cancel leaves all disks mounted.

The app does not erase, format, or write files to disks. It has no network access, telemetry, or background service, and requests no special entitlements.

### License

MIT. See [LICENSE](LICENSE).

---

<a id="русский"></a>
## Русский

<p align="center">
  <img src="docs/images/menu-bar-connected.svg" width="128" height="128" alt="Квадратный значок Quick Eject с янтарным символом, когда внешний диск подключён">
  <img src="docs/images/menu-bar-disconnected.svg" width="128" height="128" alt="Квадратный значок Quick Eject со светло-серым символом, когда внешних дисков нет">
</p>

Quick Eject — небольшая утилита для строки меню macOS. Она безопасно извлекает внешние диски только после подтверждения пользователя.

### Возможности

- **Левый клик** по значку показывает подключённые внешние тома и запрос подтверждения.
- **Правый клик** открывает меню приложения.
- Значок квадратный, с тёмным скруглённым фоном, чтобы быть заметным на строке меню. Символ извлечения янтарный при подключённых внешних дисках и светло-серый, когда их нет; состояние обновляется при подключении и извлечении дисков.
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

### Скачать, установить и запустить

[Скачайте скомпилированное приложение для macOS](https://github.com/tradingshop/quick-eject/raw/refs/heads/main/dist/Quick-Eject-macOS.zip) и распакуйте архив. Скопируйте `Quick Eject.app` в `/Applications` и откройте его. Чтобы приложение запускалось при входе в систему, добавьте его в **Системные настройки → Основные → Объекты входа**.

### Безопасность и конфиденциальность

Quick Eject рассматривает подключённые внешние тома в `/Volumes`. Перед подтверждением закройте файлы и приложения, которые используют диск. Если диск занят, macOS может отказать в извлечении; приложение покажет результат. Кнопка отмены оставляет все диски подключёнными.

Приложение не стирает, не форматирует и не записывает файлы на диски. Оно не использует сеть, телеметрию или фоновую службу и не запрашивает специальных разрешений.

### Лицензия

MIT. См. файл [LICENSE](LICENSE).
