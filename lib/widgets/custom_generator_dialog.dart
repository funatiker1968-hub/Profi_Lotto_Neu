import 'package:flutter/material.dart';
import '../core/models/lottery_model.dart';

class CustomGeneratorDialog extends StatefulWidget {
  final LotterySystem system;
  final Function(List<int> numbers) onGenerate;

  const CustomGeneratorDialog({
    super.key,
    required this.system,
    required this.onGenerate,
  });

  @override
  State<CustomGeneratorDialog> createState() => _CustomGeneratorDialogState();
}

class _CustomGeneratorDialogState extends State<CustomGeneratorDialog> {
  final TextEditingController _favoritesController = TextEditingController();
  final TextEditingController _excludedController = TextEditingController();
  bool _preferHotNumbers = false;

  List<int> _parseNumbers(String input) {
    return input
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => int.tryParse(s))
        .where((number) => number != null)
        .cast<int>()
        .toList();
  }

  void _generateNumbers() {
    final favorites = _parseNumbers(_favoritesController.text);
    // excluded wird momentan nicht verwendet, aber für zukünftige Erweiterungen behalten
    final _ = _parseNumbers(_excludedController.text);
    
    widget.onGenerate(favorites);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Individueller Generator'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _favoritesController,
              decoration: const InputDecoration(
                labelText: 'Lieblingszahlen (komma-getrennt)',
                hintText: 'z.B. 7, 13, 42',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _excludedController,
              decoration: const InputDecoration(
                labelText: 'Ausgeschlossene Zahlen (komma-getrennt)',
                hintText: 'z.B. 1, 2, 3',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Hot Numbers bevorzugen'),
              value: _preferHotNumbers,
              onChanged: (value) {
                setState(() {
                  _preferHotNumbers = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _generateNumbers,
          child: const Text('Generieren'),
        ),
      ],
    );
  }
}
