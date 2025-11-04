# 🔐 CODEMAGIC SETUP ANLEITUNG

## 📋 VORBEREITUNG FÜR CODEMAGIC

### 1. Repository auf Codemagic einrichten
- https://codemagic.io/app aufrufen
- "Add application" auswählen
- GitHub Repository: `funatiker1968-hub/Profi_Lotto_Neu`
- Branch: `main`

### 2. Environment Variables setzen
In Codemagic unter "Environment variables" für Workflow `lotto-app-android`:

#### Gruppe: `android_credentials`
- `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` - Google Play Service Account JSON

### 3. Google Play Console vorbereiten
1. In Google Play Console:
   - App erstellen: `com.lottoapp.neustart`
   - App-Name: "Lotto App Neustart"
2. Service Account erstellen:
   - Settings → API access → Service accounts
   - Neuen Service Account erstellen
   - Berechtigungen geben
   - JSON Key herunterladen
3. JSON Key in Codemagic als Environment Variable `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` einfügen

### 4. Ersten Build starten
- In Codemagic: Workflow `lotto-app-android` auswählen
- "Start new build" klicken
- Branch `main` auswählen
- Build starten

### 5. Nach erfolgreichem Build
- APK wird automatisch an Google Play Internal Track gesendet
- Email-Benachrichtigung bei Erfolg/Fehler

## 🔧 TECHNISCHE VORRAUSSETZUNGEN
- Flutter 3.22.0
- Android SDK
- Java 17
- Google Play Service Account

## 📱 APP INFORMATIONEN
- **Package Name**: com.lottoapp.neustart
- **App Name**: Lotto App Neustart
- **Version**: 1.0.0
- **Ziel-Android**: minSdk 21, targetSdk 31
