import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/lottery_service.dart';
import '../../core/services/language_service.dart';
import '../../core/services/theme_service.dart';
import '../../core/models/lottery_model.dart';
import '../../widgets/tipp_sheet.dart';
import '../../widgets/custom_generator_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LotteryService _service = LotteryService();
  LotterySystem _currentSystem = const LotterySystem(
    id: '6aus49',
    name: '6aus49',
    minNumber: 1,
    maxNumber: 49,
    picksNeeded: 6,
  );
  List<int> _currentTip = [];
  bool _showTippSheet = false;

  void _generateTip() {
    setState(() {
      _currentTip = _service.generateTip(_currentSystem);
      _showTippSheet = true;
    });
  }

  void _showCustomGenerator() {
    showDialog(
      context: context,
      builder: (context) => CustomGeneratorDialog(
        system: _currentSystem,
        onGenerate: (favorites) {
          if (favorites.isNotEmpty) {
            setState(() {
              _currentTip = _service.generateCustomTip(
                system: _currentSystem,
                favoriteNumbers: favorites,
              );
              _showTippSheet = true;
            });
          }
        },
      ),
    );
  }

  void _analyzeCustomNumbers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eigene Zahlen analysieren'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Zahlen komma-getrennt eingeben (z.B. 7,13,21,28,35,42)',
          ),
          onSubmitted: (value) {
            final numbers = value
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .map((s) => int.tryParse(s))
                .where((number) => number != null)
                .cast<int>()
                .toList();
            
            if (numbers.length == _currentSystem.picksNeeded) {
              setState(() {
                _currentTip = numbers;
                _showTippSheet = true;
              });
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  void _changeSystem(LotterySystem system) {
    setState(() {
      _currentSystem = system;
      _currentTip = [];
      _showTippSheet = false;
    });
  }

  void _closeTippSheet() {
    setState(() {
      _showTippSheet = false;
    });
  }

  void _updateNumbers(List<int> newNumbers) {
    setState(() {
      _currentTip = newNumbers;
    });
  }

  void _showLanguageDialog(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache wählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languageService.availableLanguages.map((language) {
            return ListTile(
              leading: Text(language['flag']!),
              title: Text(language['name']!),
              onTap: () {
                languageService.setLanguage(language['code']!);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final themeService = Provider.of<ThemeService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.getText('app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
            tooltip: 'Sprache wechseln',
          ),
          IconButton(
            icon: Icon(themeService.themeMode == ThemeMode.dark 
                ? Icons.light_mode 
                : Icons.dark_mode),
            onPressed: themeService.toggleTheme,
            tooltip: 'Theme wechseln',
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<LotterySystem>(
                  value: _currentSystem,
                  onChanged: (LotterySystem? newSystem) {
                    if (newSystem != null) _changeSystem(newSystem);
                  },
                  items: _service.systems.map((system) {
                    return DropdownMenuItem<LotterySystem>(
                      value: system,
                      child: Text(system.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(_currentSystem.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: _generateTip,
                  child: Text(languageService.getText('generate_tip')),
                ),
                const SizedBox(height: 10),
                
                OutlinedButton(
                  onPressed: _showCustomGenerator,
                  child: const Text('Individueller Generator'),
                ),
                const SizedBox(height: 10),
                
                OutlinedButton(
                  onPressed: _analyzeCustomNumbers,
                  child: const Text('Eigene Zahlen analysieren'),
                ),
                
                const SizedBox(height: 20),
                if (_currentTip.isNotEmpty && !_showTippSheet)
                  Text(_currentTip.join(' - '), style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
          if (_showTippSheet && _currentTip.isNotEmpty)
            TippSheet(
              system: _currentSystem,
              numbers: _currentTip,
              onClose: _closeTippSheet,
              onNumbersChanged: _updateNumbers,
            ),
        ],
      ),
    );
  }
}
