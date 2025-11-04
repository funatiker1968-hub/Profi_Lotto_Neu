import 'package:flutter/material.dart';
import '../core/models/lottery_model.dart';

class CustomSystemDialog extends StatefulWidget {
  final Function(LotterySystem) onSystemCreated;

  const CustomSystemDialog({
    super.key,
    required this.onSystemCreated,
  });

  @override
  State<CustomSystemDialog> createState() => _CustomSystemDialogState();
}

class _CustomSystemDialogState extends State<CustomSystemDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _minNumberController = TextEditingController(text: '1');
  final TextEditingController _maxNumberController = TextEditingController(text: '49');
  final TextEditingController _picksNeededController = TextEditingController(text: '6');
  final TextEditingController _bonusMinController = TextEditingController(text: '0');
  final TextEditingController _bonusMaxController = TextEditingController(text: '0');
  final TextEditingController _bonusPicksController = TextEditingController(text: '0');
  final TextEditingController _bonusNameController = TextEditingController();

  void _createCustomSystem() {
    final name = _nameController.text.trim();
    final minNumber = int.tryParse(_minNumberController.text) ?? 1;
    final maxNumber = int.tryParse(_maxNumberController.text) ?? 49;
    final picksNeeded = int.tryParse(_picksNeededController.text) ?? 6;
    final bonusMin = int.tryParse(_bonusMinController.text) ?? 0;
    final bonusMax = int.tryParse(_bonusMaxController.text) ?? 0;
    final bonusPicks = int.tryParse(_bonusPicksController.text) ?? 0;
    final bonusName = _bonusNameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Namen eingeben')),
      );
      return;
    }

    if (minNumber >= maxNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Max muss größer als Min sein')),
      );
      return;
    }

    if (picksNeeded > (maxNumber - minNumber + 1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zu viele Zahlen für den Bereich')),
      );
      return;
    }

    final customSystem = LotterySystem(
      id: 'custom_${name.toLowerCase()}',
      name: name,
      minNumber: minNumber,
      maxNumber: maxNumber,
      picksNeeded: picksNeeded,
      bonusMinNumber: bonusMin,
      bonusMaxNumber: bonusMax,
      bonusPicksNeeded: bonusPicks,
      bonusName: bonusName,
    );

    widget.onSystemCreated(customSystem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eigenes Lottosystem erstellen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'System Name',
                hintText: 'z.B. Mein Lotto',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Min Zahl',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Max Zahl',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _picksNeededController,
              decoration: const InputDecoration(
                labelText: 'Anzahl Zahlen',
                hintText: 'z.B. 6',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bonus-Zahlen (optional):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bonusNameController,
              decoration: const InputDecoration(
                labelText: 'Bonus Name',
                hintText: 'z.B. Superzahl, Eurozahlen',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bonusMinController,
                    decoration: const InputDecoration(
                      labelText: 'Bonus Min',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _bonusMaxController,
                    decoration: const InputDecoration(
                      labelText: 'Bonus Max',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _bonusPicksController,
                    decoration: const InputDecoration(
                      labelText: 'Anzahl Bonus',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
          onPressed: _createCustomSystem,
          child: const Text('Erstellen'),
        ),
      ],
    );
  }
}
