import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  final Map<String, Map<String, String>> _translations = {
    'de': {
      'app_title': 'Lotto App',
      'disclaimer_title': 'Haftungsausschluss',
      'disclaimer_text': 'Diese App dient nur zu Unterhaltungszwecken. Glücksspiel kann süchtig machen. Keine Gewähr für Richtigkeit der Daten. Mindestalter: 18 Jahre.',
      'accept': 'Akzeptieren',
      'decline': 'Ablehnen',
      'generate_tip': 'Tipp generieren',
      'statistics': 'Statistik',
      'home': 'Home',
    },
    'en': {
      'app_title': 'Lotto App', 
      'disclaimer_title': 'Disclaimer',
      'disclaimer_text': 'This app is for entertainment only. Gambling can be addictive. No warranty for data accuracy. Minimum age: 18 years.',
      'accept': 'Accept',
      'decline': 'Decline', 
      'generate_tip': 'Generate Tip',
      'statistics': 'Statistics',
      'home': 'Home',
    },
    'tr': {
      'app_title': 'Loto Uygulaması',
      'disclaimer_title': 'Sorumluluk Reddi',
      'disclaimer_text': 'Bu uygulama sadece eğlence amaçlıdır. Kumar bağımlılık yapabilir. Veri doğruluğu garanti edilmez. Minimum yaş: 18 yıl.',
      'accept': 'Kabul Et',
      'decline': 'Reddet',
      'generate_tip': 'Tahmin Oluştur',
      'statistics': 'İstatistikler', 
      'home': 'Ana Sayfa',
    }
  };

  String _currentLanguage = 'de';

  String get currentLanguage => _currentLanguage;
  
  String getFlag(String languageCode) {
    switch (languageCode) {
      case 'de': return '🇩🇪';
      case 'en': return '🇺🇸'; 
      case 'tr': return '🇹🇷';
      default: return '🌐';
    }
  }

  String getText(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'de';
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  List<Map<String, String>> get availableLanguages => [
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
  ];
}
