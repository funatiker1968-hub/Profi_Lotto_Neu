import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/lottery_service.dart';
import '../../core/services/statistics_service.dart';
import '../../core/services/language_service.dart';
import '../../core/models/lottery_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final LotteryService _lotteryService = LotteryService();
  final StatisticsService _statsService = StatisticsService();
  LotterySystem _currentSystem = const LotterySystem(
    id: '6aus49',
    name: '6aus49',
    minNumber: 1,
    maxNumber: 49,
    picksNeeded: 6,
  );

  void _changeSystem(LotterySystem system) {
    setState(() {
      _currentSystem = system;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final stats = _statsService.getHotColdNumbers(_currentSystem);
    final recentDraws = _statsService.getRecentDraws(_currentSystem);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageService.getText('statistics')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Auswahl
            DropdownButton<LotterySystem>(
              value: _currentSystem,
              onChanged: (LotterySystem? newSystem) {
                if (newSystem != null) _changeSystem(newSystem);
              },
              items: _lotteryService.systems.map((system) {
                return DropdownMenuItem<LotterySystem>(
                  value: system,
                  child: Text(system.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            
            // Hot Numbers
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔥 Hot Numbers (häufig gezogen)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: (stats['hotNumbers'] as List<int>).map((number) {
                        return Chip(
                          backgroundColor: Colors.red[100],
                          label: Text(
                            number.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Cold Numbers
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '❄️ Cold Numbers (selten gezogen)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: (stats['coldNumbers'] as List<int>).map((number) {
                        return Chip(
                          backgroundColor: Colors.blue[100],
                          label: Text(
                            number.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Letzte Ziehungen
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📅 Letzte Ziehungen',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text('Anzahl Ziehungen: ${stats['totalDraws']}'),
                    Text('Letztes Update: ${stats['lastUpdate']}'),
                    const SizedBox(height: 10),
                    ...recentDraws.take(3).map((draw) {
                      return ListTile(
                        title: Text(draw['numbers'].join(' - ')),
                        subtitle: Text(draw['date']),
                        dense: true,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
