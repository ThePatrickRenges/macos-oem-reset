#!/bin/bash

# ============================================================
# macOS OEM Reset Script - TUI Edition
# Für OCLP-gepatchte Systeme
# ============================================================
# WARNUNG: Dieses Script löscht Benutzerdaten!
# ============================================================

set -euo pipefail  # Strikte Fehlerbehandlung

# Farben (nur ASCII-Quotes!)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Globale Variablen
SCRIPT_VERSION="2.0"
DRY_RUN=false
BACKUP_HOME=false
DELETE_USER=true
DELETE_HOME=true
CLEAN_CACHES=true
CLEAN_LOGS=true
RESET_SETUP=true
AUTO_REBOOT=true

# ============================================================
# Hilfsfunktionen
# ============================================================

show_header() {
    clear
    echo -e "${BLUE}"
    echo "============================================================"
    echo "  macOS OEM Reset Script v${SCRIPT_VERSION}"
    echo "  Für OCLP-gepatchte Systeme"
    echo "============================================================"
    echo -e "${NC}"
}

check_dependencies() {
    if ! command -v whiptail &> /dev/null; then
        echo -e "${RED}Fehler: whiptail nicht gefunden!${NC}"
        echo "Installiere mit: brew install newt"
        exit 1
    fi
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        whiptail --title "Root-Rechte erforderlich" --msgbox "Dieses Script muss mit sudo ausgeführt werden!\n\nBitte starte es mit:\nsudo $0" 12 60
        exit 1
    fi
}

get_current_user() {
    stat -f%Su /dev/console
}

# ============================================================
# TUI Menüs
# ============================================================

show_main_menu() {
    local CURRENT_USER=$(get_current_user)
    
    whiptail --title "OEM Reset - Hauptmenü" --menu \
        "Aktueller Benutzer: ${CURRENT_USER}\n\nWähle eine Option:" 20 70 10 \
        "1" "⚙️  Optionen konfigurieren" \
        "2" "▶️  OEM-Reset durchführen" \
        "3" "🧪 Dry-Run (Test-Modus)" \
        "4" "ℹ️  Informationen anzeigen" \
        "5" "❌ Beenden" \
        3>&1 1>&2 2>&3
}

show_options_menu() {
    local CURRENT_USER=$(get_current_user)
    
    # Checkboxen für Optionen
    local OPTIONS=$(whiptail --title "Optionen konfigurieren" --checklist \
        "Wähle die durchzuführenden Aktionen:" 20 70 8 \
        "DELETE_USER" "Benutzer '${CURRENT_USER}' löschen" ON \
        "DELETE_HOME" "Home-Verzeichnis entfernen" ON \
        "CLEAN_CACHES" "System-Caches leeren" ON \
        "CLEAN_LOGS" "System-Logs bereinigen" ON \
        "RESET_SETUP" "Setup-Assistent aktivieren" ON \
        "AUTO_REBOOT" "Automatisch neu starten" ON \
        "BACKUP_HOME" "Home-Verzeichnis vorher sichern" OFF \
        3>&1 1>&2 2>&3)
    
    if [ $? -eq 0 ]; then
        # Alle auf false setzen
        DELETE_USER=false
        DELETE_HOME=false
        CLEAN_CACHES=false
        CLEAN_LOGS=false
        RESET_SETUP=false
        AUTO_REBOOT=false
        BACKUP_HOME=false
        
        # Gewählte auf true setzen
        for option in $OPTIONS; do
            option=$(echo "$option" | tr -d '"')
            case "$option" in
                DELETE_USER) DELETE_USER=true ;;
                DELETE_HOME) DELETE_HOME=true ;;
                CLEAN_CACHES) CLEAN_CACHES=true ;;
                CLEAN_LOGS) CLEAN_LOGS=true ;;
                RESET_SETUP) RESET_SETUP=true ;;
                AUTO_REBOOT) AUTO_REBOOT=true ;;
                BACKUP_HOME) BACKUP_HOME=true ;;
            esac
        done
        
        whiptail --title "Optionen gespeichert" --msgbox "Konfiguration wurde aktualisiert!" 8 50
    fi
}

show_info() {
    local CURRENT_USER=$(get_current_user)
    local MACOS_VERSION=$(sw_vers -productVersion)
    local HOME_SIZE="N/A"
    
    if [ -d "/Users/${CURRENT_USER}" ]; then
        HOME_SIZE=$(du -sh "/Users/${CURRENT_USER}" 2>/dev/null | cut -f1)
    fi
    
    whiptail --title "System-Informationen" --msgbox \
        "macOS Version: ${MACOS_VERSION}\n\nAktueller Benutzer: ${CURRENT_USER}\nHome-Verzeichnis: /Users/${CURRENT_USER}\nGröße: ${HOME_SIZE}\n\nOCLP-Patches: Bleiben erhalten\nSystemweite Apps: Bleiben erhalten" 16 60
}

confirm_reset() {
    local CURRENT_USER=$(get_current_user)
    local MODE="LIVE"
    
    if [ "$DRY_RUN" = true ]; then
        MODE="TEST (Dry-Run)"
    fi
    
    whiptail --title "⚠️  Letzte Bestätigung" --yesno \
        "WARNUNG: Folgende Aktionen werden durchgeführt:\n\nModus: ${MODE}\nBenutzer: ${CURRENT_USER}\n\n$(get_action_list)\n\nMöchtest du wirklich fortfahren?" 20 70
}

get_action_list() {
    local actions=""
    [ "$DELETE_USER" = true ] && actions="${actions}✓ Benutzer löschen\n"
    [ "$DELETE_HOME" = true ] && actions="${actions}✓ Home-Verzeichnis entfernen\n"
    [ "$BACKUP_HOME" = true ] && actions="${actions}✓ Home-Verzeichnis vorher sichern\n"
    [ "$CLEAN_CACHES" = true ] && actions="${actions}✓ System-Caches leeren\n"
    [ "$CLEAN_LOGS" = true ] && actions="${actions}✓ System-Logs bereinigen\n"
    [ "$RESET_SETUP" = true ] && actions="${actions}✓ Setup-Assistent aktivieren\n"
    [ "$AUTO_REBOOT" = true ] && actions="${actions}✓ Automatisch neu starten\n"
    echo -e "$actions"
}

# ============================================================
# Ausführungsfunktionen
# ============================================================

execute_step() {
    local step_name="$1"
    local step_cmd="$2"
    
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] ${step_name}"
        return 0
    fi
    
    echo "${step_name}"
    eval "$step_cmd" 2>/dev/null || true
}

backup_home_directory() {
    local CURRENT_USER=$(get_current_user)
    local BACKUP_DIR="/Users/Deleted Users"
    local TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    
    if [ ! "$DRY_RUN" = true ]; then
        mkdir -p "$BACKUP_DIR"
        mv "/Users/${CURRENT_USER}" "${BACKUP_DIR}/${CURRENT_USER}_${TIMESTAMP}"
    fi
    echo "✓ Backup erstellt: ${BACKUP_DIR}/${CURRENT_USER}_${TIMESTAMP}"
}

perform_reset() {
    local CURRENT_USER=$(get_current_user)
    local STEP=1
    local TOTAL=6
    
    {
        # Schritt 1: Backup (optional)
        if [ "$BACKUP_HOME" = true ]; then
            echo "XXX"
            echo "$((STEP * 100 / TOTAL))"
            echo "Erstelle Backup des Home-Verzeichnisses..."
            echo "XXX"
            backup_home_directory
            STEP=$((STEP + 1))
            sleep 1
        fi
        
        # Schritt 2: Benutzer löschen
        if [ "$DELETE_USER" = true ]; then
            echo "XXX"
            echo "$((STEP * 100 / TOTAL))"
            echo "Lösche Benutzer aus Verzeichnisdatenbank..."
            echo "XXX"
            execute_step "Benutzer löschen" "dscl . -delete '/Users/${CURRENT_USER}'"
            STEP=$((STEP + 1))
            sleep 1
        fi
        
        # Schritt 3: Home-Verzeichnis löschen
        if [ "$DELETE_HOME" = true ] && [ "$BACKUP_HOME" = false ]; then
            echo "XXX"
            echo "$((STEP * 100 / TOTAL))"
            echo "Entferne Home-Verzeichnis..."
            echo "XXX"
            execute_step "Home löschen" "rm -rf '/Users/${CURRENT_USER}'"
            STEP=$((STEP + 1))
            sleep 1
        fi
        
        # Schritt 4: Caches leeren
        if [ "$CLEAN_CACHES" = true ]; then
            echo "XXX"
            echo "$((STEP * 100 / TOTAL))"
            echo "Leere System-Caches..."
            echo "XXX"
            execute_step "Caches leeren" "rm -rf /Library/Caches/* /System/Library/Caches/*"
            STEP=$((STEP + 1))
            sleep 1
        fi
        
        # Schritt 5: Logs bereinigen
        if [ "$CLEAN_LOGS" = true ]; then
            echo "XXX"
            echo "$((STEP * 100 / TOTAL))"
            echo "Bereinige System-Logs..."
            echo "XXX"
            execute_step "Logs bereinigen" "rm -rf /private/var/log/* /Library/Logs/*"
            STEP=$((STEP + 1))
            sleep 1
        fi
        
        # Schritt 6: Setup-Assistent aktivieren
        if [ "$RESET_SETUP" = true ]; then
            echo "XXX"
            echo "$((STEP * 100 / TOTAL))"
            echo "Aktiviere Setup-Assistenten..."
            echo "XXX"
            execute_step "Setup aktivieren" "rm -f /var/db/.AppleSetupDone"
            STEP=$((STEP + 1))
            sleep 1
        fi
        
        echo "XXX"
        echo "100"
        echo "Abgeschlossen!"
        echo "XXX"
        sleep 1
        
    } | whiptail --title "OEM-Reset wird durchgeführt..." --gauge "Starte..." 8 70 0
}

# ============================================================
# Hauptprogramm
# ============================================================

main() {
    show_header
    check_dependencies
    check_root
    
    while true; do
        CHOICE=$(show_main_menu)
        
        case $CHOICE in
            1)
                show_options_menu
                ;;
            2)
                DRY_RUN=false
                if confirm_reset; then
                    perform_reset
                    
                    if [ "$DRY_RUN" = false ]; then
                        whiptail --title "✅ Erfolgreich" --msgbox "OEM-Reset wurde erfolgreich durchgeführt!\n\nOCLP-Patches bleiben erhalten." 10 60
                        
                        if [ "$AUTO_REBOOT" = true ]; then
                            whiptail --title "Neustart" --msgbox "System wird in 5 Sekunden neu gestartet..." 8 50
                            sleep 5
                            reboot
                        fi
                    fi
                fi
                ;;
            3)
                DRY_RUN=true
                if confirm_reset; then
                    perform_reset
                    whiptail --title "Dry-Run abgeschlossen" --msgbox "Test-Durchlauf abgeschlossen.\nKeine echten Änderungen wurden vorgenommen." 10 60
                fi
                DRY_RUN=false
                ;;
            4)
                show_info
                ;;
            5|*)
                if whiptail --title "Beenden" --yesno "Möchtest du das Script wirklich beenden?" 8 50; then
                    echo -e "${GREEN}Auf Wiedersehen!${NC}"
                    exit 0
                fi
                ;;
        esac
    done
}

# Script starten
main
