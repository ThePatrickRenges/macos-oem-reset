# macOS OEM Reset

Universal tool für die Erstellung von OEM-ähnlichen macOS-Installationen, speziell optimiert für **OpenCore Legacy Patcher (OCLP)** gepatchte Systeme.

![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)
![macOS](https://img.shields.io/badge/macOS-Big%20Sur%20%7C%20Monterey%20%7C%20Ventura%20%7C%20Sonoma%20%7C%20Sequoia-lightgrey)
![Version](https://img.shields.io/badge/version-2.0.0-brightgreen.svg)

---

## 📦 Verfügbare Versionen

### 🖥️ Version 2.0 - macOS App (Empfohlen)

**Native SwiftUI Anwendung für Intel & Apple Silicon Macs**

[![Download App](https://img.shields.io/badge/Download-macOS%20App%20v2.0-blue.svg?style=for-the-badge)](https://github.com/ThePatrickRenges/macos-oem-reset/releases/latest)

**Features:**
- ✨ Moderne native macOS-Oberfläche
- 🔄 Universal Binary (Intel + Apple Silicon)
- 🎛️ Integrierter OCLP-Manager
- 📊 Echtzeit-Fortschrittsanzeige
- 🧪 Dry-Run Test-Modus
- 📝 Detailliertes Activity-Log

**Installation:**
```bash
# Download .dmg von Releases
# Drag & Drop zu Applications
# Öffne OEMReset.app
```

→ **[Zur App-Dokumentation](macos-app/README.md)**

---

### ⚙️ Version 1.0 - CLI Script

**Shell-basiertes TUI für fortgeschrittene Benutzer**

[![Download Script](https://img.shields.io/badge/Download-CLI%20Script%20v1.0-green.svg?style=for-the-badge)](https://github.com/ThePatrickRenges/macos-oem-reset/blob/main/cli-version/oem_reset_tui.sh)

**Features:**
- 🖥️ Interaktive Terminal-Oberfläche (whiptail)
- 🔧 Vollständige Kontrolle über alle Optionen
- 📦 Keine Installation notwendig
- 🚀 Leichtgewichtig und schnell

**Installation:**
```bash
# Download Script
wget https://raw.githubusercontent.com/ThePatrickRenges/macos-oem-reset/main/cli-version/oem_reset_tui.sh

# Ausführbar machen
chmod +x oem_reset_tui.sh

# Mit sudo ausführen
sudo ./oem_reset_tui.sh
```

→ **[Zur CLI-Dokumentation](cli-version/README.md)**

---

## 📋 Was macht das Tool?

Dieses Tool ermöglicht es, ein macOS-System nach der Konfiguration in einen "Auslieferungszustand" zurückzuversetzen - ähnlich einem fabrikneuen Mac. Dabei bleiben systemweite Änderungen, OCLP-Root-Patches und installierte Anwendungen erhalten, während temporäre Benutzer-Accounts und persönliche Daten entfernt werden.

### ✅ Perfekt für:

- Erstellen von Golden-Master-Images
- Vorbereitung von Macs für Weitergabe/Verkauf
- OEM-ähnliche Installationen mit vorinstallierten Apps
- OCLP-gepatchte Legacy-Macs (z.B. MacBook Pro 2013)

### 🔄 Was wird entfernt:

- ✓ Temporäre Benutzer-Accounts
- ✓ Home-Verzeichnisse (mit Backup-Option)
- ✓ System-Caches & Logs
- ✓ Setup Assistant wird reaktiviert

### ✅ Was bleibt erhalten:

- ✅ Alle OCLP Root-Patches
- ✅ Systemweite Anwendungen
- ✅ System-Einstellungen
- ✅ OpenCore Bootloader-Konfiguration

---

## 📸 Screenshots

### macOS App (v2.0)

<table>
  <tr>
    <td width="50%">
      <img src="macos-app/screenshots/welcome.png" alt="Welcome Screen" />
      <p align="center"><em>Welcome Screen mit System-Info</em></p>
    </td>
    <td width="50%">
      <img src="macos-app/screenshots/oclp-manager.png" alt="OCLP Manager" />
      <p align="center"><em>Integrierter OCLP Manager</em></p>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="macos-app/screenshots/reset-config.png" alt="Reset Config" />
      <p align="center"><em>Konfiguration mit Dry-Run Modus</em></p>
    </td>
    <td width="50%">
      <img src="macos-app/screenshots/progress.png" alt="Progress" />
      <p align="center"><em>Fortschrittsanzeige & Activity Log</em></p>
    </td>
  </tr>
</table>

### CLI Version (v1.0)

<table>
  <tr>
    <td width="50%">
      <img src="screenshots/unnamed.png" alt="System Info" />
      <p align="center"><em>System-Informationen</em></p>
    </td>
    <td width="50%">
      <img src="screenshots/unnamed%20(1).png" alt="Hauptmenü" />
      <p align="center"><em>Hauptmenü</em></p>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <img src="screenshots/unnamed%20(2).png" alt="Optionen" />
      <p align="center"><em>Optionen konfigurieren</em></p>
    </td>
    <td width="50%">
      <img src="screenshots/unnamed%20(3).png" alt="Bestätigung" />
      <p align="center"><em>Sicherheitsabfrage</em></p>
    </td>
  </tr>
</table>

---

## 🚀 Quick Start

### Für die meisten Benutzer (App v2.0):

1. **Download** die neueste Version von [Releases](https://github.com/ThePatrickRenges/macos-oem-reset/releases/latest)
2. **Öffne** die `.dmg` Datei
3. **Ziehe** OEMReset.app in deinen Applications-Ordner
4. **Starte** die App und folge den Anweisungen

### Für fortgeschrittene Benutzer (CLI v1.0):

```bash
# Download
git clone https://github.com/ThePatrickRenges/macos-oem-reset.git
cd macos-oem-reset/cli-version

# Ausführen
chmod +x oem_reset_tui.sh
sudo ./oem_reset_tui.sh
```

---

## 📖 Kompletter Workflow für OCLP-Systeme

**Beispiel: MacBook Pro Retina 13" (Late 2013)**

⚠️ **WICHTIG: Verwende eine frische Installation, kein Upgrade!**

```
1. ✅ macOS Sequoia 15.7 CLEAN INSTALL durchführen
2. ✅ Temporären Admin-User anlegen (z.B. "setup")
3. ✅ OCLP: Post-Install Root Patches anwenden
4. ✅ System testen (GPU-Beschleunigung, WiFi, etc.)
5. ✅ OCLP Settings: ShowPicker deaktivieren
6. ✅ OCLP: OpenCore neu bauen und installieren
7. ✅ Alle gewünschten Apps systemweit installieren
8. ✅ OEM Reset Tool ausführen (Dry-Run → Live)
9. ✅ Nach Reboot: Setup-Assistent erscheint
10. ✅ Fertiges OEM-System!
```

**Warum Clean Install?**  
Bei einer Clean Installation erscheint der echte "Neuer Mac"-Setup-Assistent, nicht der Upgrade-Assistent.

---

## 💻 System-Anforderungen

### macOS App (v2.0):
- macOS 13.0 Ventura oder neuer
- Intel oder Apple Silicon Mac
- ~20 MB Speicherplatz

### CLI Script (v1.0):
- macOS 11.0 Big Sur oder neuer
- Intel oder Apple Silicon Mac
- `whiptail` (vorinstalliert)

### Beide Versionen:
- Root-Rechte (sudo/Administrator)
- OCLP-gepatchte Systeme vollständig unterstützt

---

## ⚠️ Wichtige Hinweise

### Vor der Ausführung:

- ⚠️ **Erstelle ein vollständiges Backup (Time Machine)!**
- ⚠️ Teste zuerst im Dry-Run-Modus
- ⚠️ Bei OCLP: Post-Install Patches müssen installiert sein
- ⚠️ FileVault sollte deaktiviert sein

### Sicherheit:

- Automatische Root-Rechte-Prüfung
- Mehrfache Bestätigungen vor kritischen Aktionen
- Dry-Run-Modus für sicheres Testen
- Optionale Backup-Funktion

---

## 🐛 Troubleshooting

### macOS App Probleme

**"OEMReset.app kann nicht geöffnet werden"**
```bash
# Gatekeeper-Quarantäne entfernen
xattr -cr /Applications/OEMReset.app
```

**"App ist beschädigt"**
- Download erneut von offiziellem Release
- Prüfe SHA256 Checksumme

### CLI Script Probleme

**"whiptail nicht gefunden"**
```bash
brew install newt
```

**"Permission denied"**
```bash
chmod +x oem_reset_tui.sh
sudo ./oem_reset_tui.sh
```

**Setup-Assistent erscheint nicht**
```bash
# Prüfen ob .AppleSetupDone gelöscht wurde
ls -la /var/db/.AppleSetupDone  # Sollte nicht existieren
```

Mehr Hilfe: **[Troubleshooting Guide](docs/TROUBLESHOOTING.md)**

---

## 🤝 Beitragen

Contributions sind willkommen!

1. Fork das Repository
2. Erstelle einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Commit deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

**Entwickler-Dokumentation:** [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📝 Lizenz

Dieses Projekt ist lizenziert unter der **GNU General Public License v3.0**

Siehe [LICENSE](LICENSE) für Details.

---

## 🙏 Credits

- Entwickelt für die OpenCore Legacy Patcher Community
- Inspiriert durch die Notwendigkeit sauberer OEM-Installationen auf Legacy-Macs
- Dank an alle OCLP-Entwickler und Contributors

---

## 📞 Support & Community

- 🐛 **Bug Reports:** [GitHub Issues](https://github.com/ThePatrickRenges/macos-oem-reset/issues)
- 💬 **Fragen:** [GitHub Discussions](https://github.com/ThePatrickRenges/macos-oem-reset/discussions)
- 🗣️ **OCLP Forum:** [OpenCore Legacy Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher/discussions)

---

## ⚡ Disclaimer

Dieses Tool modifiziert Systemdateien und löscht Benutzerdaten. Verwende es auf eigene Gefahr. Der Autor übernimmt keine Haftung für Datenverlust oder Systemschäden. **Erstelle immer ein Backup vor der Verwendung!**

---

## 🗺️ Roadmap

### Version 2.1 (Geplant)
- [ ] Preset-System (Golden Master, Verkauf, etc.)
- [ ] Time Machine Integration
- [ ] Erweiterte OCLP-Konfiguration
- [ ] Mehrsprachige Unterstützung (EN/DE)

### Version 2.2 (Geplant)
- [ ] Automatische Updates
- [ ] Cloud-Backup-Option
- [ ] Template-System für wiederholbare Setups

**Feature-Requests?** → [Öffne ein Issue](https://github.com/ThePatrickRenges/macos-oem-reset/issues/new)

---

<div align="center">

**Made with ❤️ for the OCLP community**

⭐ **Gefällt dir das Projekt? Gib uns einen Stern!** ⭐

[⬇️ Download Latest Release](https://github.com/ThePatrickRenges/macos-oem-reset/releases/latest) | [📖 Documentation](docs/) | [🐛 Report Bug](https://github.com/ThePatrickRenges/macos-oem-reset/issues)

</div>
