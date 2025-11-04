import 'package:flutter/material.dart';
import '../core/services/language_service.dart';

class DisclaimerDialog extends StatefulWidget {
  final LanguageService languageService;
  final Function(bool accepted) onResult;

  const DisclaimerDialog({
    super.key,
    required this.languageService,
    required this.onResult,
  });

  @override
  State<DisclaimerDialog> createState() => _DisclaimerDialogState();
}

class _DisclaimerDialogState extends State<DisclaimerDialog> {
  String _selectedLanguage = 'de';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.languageService.currentLanguage;
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    widget.languageService.setLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.languageService.getText('disclaimer_title')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sprachauswahl
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _changeLanguage(newValue);
                }
              },
              items: widget.languageService.availableLanguages.map((language) {
                return DropdownMenuItem<String>(
                  value: language['code'],
                  child: Row(
                    children: [
                      Text(language['flag']!),
                      const SizedBox(width: 8),
                      Text(language['name']!),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(widget.languageService.getText('disclaimer_text')),
            const SizedBox(height: 20),
            Text(
              '⚠️ ${widget.languageService.getText('disclaimer_text')}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        // Ablehnen Button - Beendet App
        TextButton(
          onPressed: () {
            widget.onResult(false);
          },
          child: Text(widget.languageService.getText('decline')),
        ),
        // Akzeptieren Button
        ElevatedButton(
          onPressed: () {
            widget.onResult(true);
          },
          child: Text(widget.languageService.getText('accept')),
        ),
      ],
    );
  }
}
