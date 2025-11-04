import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerService {
  static const String _disclaimerAcceptedKey = 'disclaimer_accepted';
  
  Future<bool> isDisclaimerAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_disclaimerAcceptedKey) ?? false;
  }
  
  Future<void> setDisclaimerAccepted(bool accepted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_disclaimerAcceptedKey, accepted);
  }
}
