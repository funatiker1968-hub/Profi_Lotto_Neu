# 🧠 CHAT-GEDÄCHTNIS - ARBEITSWEISE & FORTSCHRITTE

## 🔑 ARBEITSMETHODIK FÜR NEUEN CHAT

### Befehlstruktur
```bash
echo "=== SCHRITT X: BESCHREIBUNG ==="
# Bash-Befehle hier
echo "=== ENDE SCHRITT X ==="
```

WICHTIGE REGELN

1. Immer ECHO-Nummerierung für Übersicht
2. Schritte kombinieren bei keinen Ausgaben
3. Immer Bestätigung vor nächstem Schritt
4. Debian-kompatible Bash-Befehle
5. Flutter 3.22.0 verwenden (Codemagic kompatibel)
6. Hinweise erst beim nächsten Schritt anwenden
7. Kopier-Button am Ende des Bash-Codes

BEWÄHRTE VERFAHREN

· Service-basierte Architektur
· SharedPreferences für Persistenz
· ChangeNotifier für State Management
· Immer zuerst flutter analyze vor Build
· Logs nach größeren Änderungen updaten

📋 PROJEKT-VORGABEN (Für neuen Chat)

App-Features

· 3 Lotto-Systeme: 6aus49, Eurojackpot, Sayısal Loto
· Tipp-Generierung + individueller Generator
· Statistik mit historischen Daten 2000-2024
· Tippschein Component
· DE/EN/TR + Dark/Light Mode
· BottomNavigationBar

Technische Vorgaben

· Flutter: 3.22.0 (Codemagic kompatibel)
· State Management: Einfach (setState, Provider)
· Architektur: Service-basiert
· Ziel: APK ~20MB für Samsung S6 Lite

Wichtige Hinweise

· ❌ Kein Tablet-Build (nur Codemagic)
· ❌ Kein infinite Loading
· ✅ Immer strukturierte Entwicklung in Phasen
· ✅ Kopier-Button am Bash-Ende für einfaches Kopieren

🎯 AKTUELLER FORTSCHRITT (Stand: Phase 2 abgeschlossen)

Bereits implementiert

1. Projektgrundgerüst (Schritt 1-9)
2. Datenmodelle & Services (Schritt 5-6, 17-18, 29)
3. UI Navigation (Schritt 7-9, 14, 27)
4. Disclaimer System (Schritt 22-23, 26)
5. Theme System (Schritt 29)
6. Log-System (Schritt 19-21, 30)

Nächste Prioritäten

1. Tippschein Component
2. Statistik mit historischen Daten
3. Individueller Generator

💾 GESAMTÜBERSICHT FÜR NEUSTART

```bash
# Bei Chat-Wechsel: Diese Dateien mitgeben
- PROJEKTSTATUS_LOG.md
- CHAT_GEDAECHTNIS.md
- update_logs.sh
- lib/ Verzeichnis komplett
```

❌ AUSGESCHLOSSENE FEHLERHAFTE SCHRITTE

· Keine Build-Tests auf Termux (Performance-Probleme)
· Keine Tablet-Builds (nur Codemagic)

