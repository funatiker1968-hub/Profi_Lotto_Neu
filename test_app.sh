#!/bin/bash
echo "📱 APP TESTING STARTEN..."

echo ""
echo "🔍 Teste Code-Qualität..."
flutter analyze

echo ""
echo "🧪 Führe Tests aus..."
flutter test

echo ""
echo "📦 Baue Test-APK..."
flutter build apk --debug

echo ""
echo "📊 APK-Informationen:"
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "✅ APK erfolgreich gebaut"
    echo "📍 Location: build/app/outputs/flutter-apk/app-debug.apk"
    echo "📏 Größe: $(du -h build/app/outputs/flutter-apk/app-debug.apk | cut -f1)"
    
    echo ""
    echo "📋 TEST-CHECKLISTE:"
    echo "❏ App startet ohne Fehler"
    echo "❏ Disclaimer wird angezeigt"
    echo "❏ Sprachauswahl funktioniert"
    echo "❏ Theme-Wechsel funktioniert"
    echo "❏ Tipp-Generierung funktioniert"
    echo "❏ Tippschein öffnet/schließt"
    echo "❏ Zahlen können geändert werden"
    echo "❏ Statistik zeigt Daten an"
    echo "❏ Countdown läuft"
    echo "❏ Navigation funktioniert"
else
    echo "❌ APK-Build fehlgeschlagen"
fi
