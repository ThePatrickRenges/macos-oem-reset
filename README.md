# macOS OEM Reset Script

Ein interaktives Shell-Script zur Erstellung von OEM-ähnlichen macOS-Installationen, speziell optimiert für **OpenCore Legacy Patcher (OCLP)** gepatchte Systeme.

![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)
![macOS](https://img.shields.io/badge/macOS-Big%20Sur%20%7C%20Monterey%20%7C%20Ventura%20%7C%20Sonoma%20%7C%20Sequoia-lightgrey)
![Shell](https://img.shields.io/badge/shell-bash-green.svg)

## 📋 Beschreibung

Dieses Script ermöglicht es, ein macOS-System nach einem Upgrade und der Konfiguration in einen "Auslieferungszustand" zurückzuversetzen - ähnlich einem fabrikneuen Mac. Dabei bleiben systemweite Änderungen, OCLP-Root-Patches und installierte Anwendungen erhalten, während temporäre Benutzer-Accounts und persönliche Daten entfernt werden.

**Perfekt für:**
- Erstellen von Golden-Master-Images
- Vorbereitung von Macs für Weitergabe/Verkauf
- OEM-ähnliche Installationen mit vorinstallierten Apps
- OCLP-gepatchte Legacy-Macs (z.B. MacBook Pro 2013)

## ✨ Features

- 🖥️ **Interaktive TUI** (Terminal User Interface) mit whiptail
- 🧪 **Dry-Run-Modus** zum sicheren Testen ohne echte Änderungen
- 💾 **Backup-Option** für Home-Verzeichnisse vor dem Löschen
- ⚙️ **Konfigurierbare Optionen** - wähle aus, was gelöscht werden soll
- 📊 **Fortschrittsanzeige** mit detailliertem Status
- 🔒 **Sicherheitsabfragen** und Bestätigungen
- ✅ **OCLP-kompatibel** - Root-Patches bleiben erhalten
- 🎨 **Farbige Ausgabe** für bessere Übersicht

## 📸 Screenshots

### System-Informationen
Das Script zeigt detaillierte Informationen über das aktuelle System an:

![System-Info](screenshots/unnamed.png)

### Hauptmenü
Übersichtliches Menü mit allen verfügbaren Optionen:

![Hauptmenü](screenshots/unnamed%20(1).png)

### Optionen konfigurieren
Wähle individuell, welche Aktionen durchgeführt werden sollen:

![Optionen](screenshots/unnamed%20(2).png)

### Bestätigung
Letzte Sicherheitsabfrage vor der Ausführung:

![Bestätigung](screenshots/unnamed%20(3).png)

## 🚀 Was macht das Script?

### Optionale Aktionen (individuell konfigurierbar):

- ✓ **Löscht Benutzer vollständig** aus allen Systemdatenbanken (dscl, dslocal, Secure Token, Gruppen, Keychain)
- ✓ Entfernt Home-Verzeichnisse (mit optionalem Backup)
- ✓ Leert System-Caches (`/Library/Caches`, `/System/Library/Caches`)
- ✓ Bereinigt System-Logs (`/var/log`, `/Library/Logs`)
- ✓ Reaktiviert den macOS Setup-Assistenten
- ✓ Bereinigt Directory Services Cache
- ✓ Optional: Automatischer Neustart

### Was bleibt erhalten:

- ✅ Alle OCLP Root-Patches
- ✅ Systemweite Anwendungen
- ✅ System-Einstellungen und Konfigurationen
- ✅ OpenCore Bootloader-Konfiguration

## 📦 Installation

### Voraussetzungen

- macOS Big Sur oder neuer (auch OCLP-gepatchte Versionen)
- Root-Rechte (sudo)
- `whiptail` (normalerweise vorinstalliert auf macOS)

### Download

```bash
# Repository klonen
git clone https://github.com/DEIN-USERNAME/macos-oem-reset.git
cd macos-oem-reset

# Script ausführbar machen
chmod +x oem_reset_tui.sh
```

## 🎯 Verwendung

### Schritt 1: Dry-Run (Empfohlen!)

Teste das Script zuerst im Dry-Run-Modus ohne echte Änderungen:

```bash
sudo ./oem_reset_tui.sh
```

Im Menü: Wähle **"3) 🧪 Dry-Run (Test-Modus)"**

### Schritt 2: Optionen konfigurieren

Im Hauptmenü: **"1) ⚙️ Optionen konfigurieren"**

Wähle mit der Leertaste, welche Aktionen durchgeführt werden sollen:
- Benutzer löschen
- Home-Verzeichnis entfernen
- System-Caches leeren
- System-Logs bereinigen
- Setup-Assistent aktivieren
- Automatisch neu starten
- Home-Verzeichnis vorher sichern

### Schritt 3: OEM-Reset durchführen

Im Hauptmenü: **"2) ▶️ OEM-Reset durchführen"**

Das Script führt alle konfigurierten Aktionen aus und startet (optional) neu.

## 📖 Kompletter Workflow für OCLP-Systeme

### Beispiel: MacBook Pro Retina 13" (Late 2013)

**⚠️ WICHTIG: Verwende eine frische Installation, kein Upgrade!**

```
1. ✅ macOS Sequoia 15.7 CLEAN INSTALL durchführen (nicht Upgrade!)
2. ✅ Temporären Admin-User anlegen (z.B. "setup")
3. ✅ OCLP: Post-Install Root Patches anwenden
4. ✅ System testen (GPU-Beschleunigung, WiFi, etc.)
5. ✅ OCLP Settings: ShowPicker deaktivieren
6. ✅ OCLP: OpenCore neu bauen und installieren
7. ✅ Alle gewünschten Apps systemweit installieren
8. ✅ Dry-Run: sudo ./oem_reset_tui.sh (Menü: 3)
9. ✅ Live-Ausführung: sudo ./oem_reset_tui.sh (Menü: 2)
10. ✅ Nach Reboot: Setup-Assistent für NEUEN Benutzer erscheint
11. ✅ Fertiges OEM-System!
```

### Warum Clean Install statt Upgrade?

Bei einem Upgrade (Big Sur → Sequoia) zeigt macOS den "Upgrade-Setup-Assistenten", der bestehende User erwartet. Bei einer Clean Installation erscheint der echte "Neuer Mac"-Setup-Assistent, der nach einem komplett neuen Benutzer fragt - genau was wir für ein OEM-System wollen!

## 🖥️ TUI-Navigation

- **↑/↓** - Navigation durch Menüpunkte
- **Leertaste** - Checkbox an/ausschalten
- **Enter** - Auswahl bestätigen
- **ESC** - Abbrechen

## ⚠️ Wichtige Hinweise

### Vor der Ausführung:

- ⚠️ **Erstelle ein vollständiges Backup!**
- ⚠️ Stelle sicher, dass alle wichtigen Daten extern gesichert sind
- ⚠️ Teste zuerst im Dry-Run-Modus
- ⚠️ Bei OCLP: Post-Install Patches MÜSSEN vorher installiert sein
- ⚠️ FileVault sollte deaktiviert sein (oder bewusst damit umgehen)

### Sicherheit:

- Das Script prüft automatisch auf Root-Rechte
- Mehrfache Bestätigungen vor kritischen Aktionen
- Dry-Run-Modus für sicheres Testen
- Optionale Backup-Funktion

## 🐛 Troubleshooting

### "whiptail nicht gefunden"

```bash
# Auf macOS normalerweise vorinstalliert
# Falls nicht: Mit Homebrew installieren
brew install newt
```

### "Permission denied"

```bash
# Script ausführbar machen
chmod +x oem_reset_tui.sh

# Mit sudo ausführen
sudo ./oem_reset_tui.sh
```

### Setup-Assistent erscheint nicht nach Reboot

Prüfe, ob `.AppleSetupDone` wirklich gelöscht wurde:
```bash
ls -la /var/db/.AppleSetupDone
# Sollte nicht existieren
```

### Upgrade-Setup statt "Neuer Mac"-Setup

**Problem:** Nach dem Script erscheint der Upgrade-Assistent statt des echten Setup-Assistenten.

**Lösung:** Stelle sicher, dass du eine **Clean Installation** von macOS durchgeführt hast, nicht ein Upgrade von einer älteren Version. Das Script funktioniert am besten mit frischen Installationen.

### Benutzer erscheint nach Reboot wieder

**Problem:** Der gelöschte Benutzer ist nach dem Neustart wieder da.

**Lösung:** Script v2.1 oder neuer verwenden! Ältere Versionen löschen den Benutzer nicht vollständig. Die neue Version entfernt User aus allen Systemdatenbanken (dscl, dslocal, Secure Token, etc.).

## 🤝 Beitragen

Contributions sind willkommen! 

1. Fork das Repository
2. Erstelle einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Commit deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

## 📝 Lizenz

Dieses Projekt ist lizenziert unter der **GNU General Public License v3.0** - siehe [LICENSE](LICENSE) Datei für Details.

## 🙏 Credits

- Entwickelt für die OpenCore Legacy Patcher Community
- Inspiriert durch die Notwendigkeit sauberer OEM-Installationen auf Legacy-Macs
- Dank an alle OCLP-Entwickler und Contributors

## 📞 Support

Bei Fragen oder Problemen:
- Öffne ein Issue auf GitHub
- OCLP-Forum: [OpenCore Legacy Patcher Discussions](https://github.com/dortania/OpenCore-Legacy-Patcher/discussions)

## ⚡ Disclaimer

Dieses Script modifiziert Systemdateien und löscht Benutzerdaten. Verwende es auf eigene Gefahr. Der Autor übernimmt keine Haftung für Datenverlust oder Systemschäden. Erstelle immer ein Backup vor der Verwendung!

---

**Made with ❤️ for the OCLP community**