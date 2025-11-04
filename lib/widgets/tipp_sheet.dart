import 'package:flutter/material.dart';
import '../core/models/lottery_model.dart';
import '../core/services/statistics_service.dart';

class TippSheet extends StatefulWidget {
  final LotterySystem system;
  final List<int> numbers;
  final VoidCallback onClose;
  final Function(List<int>) onNumbersChanged;

  const TippSheet({
    super.key,
    required this.system,
    required this.numbers,
    required this.onClose,
    required this.onNumbersChanged,
  });

  @override
  State<TippSheet> createState() => _TippSheetState();
}

class _TippSheetState extends State<TippSheet> {
  late List<int> _currentNumbers;
  final StatisticsService _statsService = StatisticsService();
  Map<String, dynamic>? _analysis;

  @override
  void initState() {
    super.initState();
    _currentNumbers = List.from(widget.numbers);
    _analyzeNumbers();
  }

  void _analyzeNumbers() {
    final analysis = _statsService.analyzeNumbers(_currentNumbers, widget.system);
    setState(() {
      _analysis = analysis;
    });
  }

  void _updateNumber(int index, int newNumber) {
    if (newNumber >= widget.system.minNumber && 
        newNumber <= widget.system.maxNumber &&
        !_currentNumbers.contains(newNumber)) {
      
      setState(() {
        _currentNumbers[index] = newNumber;
        _currentNumbers.sort();
      });
      
      widget.onNumbersChanged(_currentNumbers);
      _analyzeNumbers();
    }
  }

  void _addCustomNumber() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eigene Zahl hinzufügen'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Zahl zwischen ${widget.system.minNumber}-${widget.system.maxNumber}',
          ),
          onSubmitted: (value) {
            final number = int.tryParse(value);
            if (number != null && 
                number >= widget.system.minNumber && 
                number <= widget.system.maxNumber &&
                !_currentNumbers.contains(number) &&
                _currentNumbers.length < widget.system.picksNeeded) {
              
              setState(() {
                _currentNumbers.add(number);
                _currentNumbers.sort();
              });
              
              widget.onNumbersChanged(_currentNumbers);
              _analyzeNumbers();
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

  void _removeNumber(int number) {
    setState(() {
      _currentNumbers.remove(number);
    });
    widget.onNumbersChanged(_currentNumbers);
    _analyzeNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tippschein - ${widget.system.name}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Deine Zahlen (antippen zum Ändern):',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _currentNumbers.asMap().entries.map((entry) {
                              final index = entry.key;
                              final number = entry.value;
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Zahl ändern'),
                                      content: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Neue Zahl (${widget.system.minNumber}-${widget.system.maxNumber})',
                                        ),
                                        onSubmitted: (value) {
                                          final newNumber = int.tryParse(value);
                                          if (newNumber != null) {
                                            _updateNumber(index, newNumber);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('Abbrechen'),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            _removeNumber(number);
                                            Navigator.of(context).pop();
                                          },
                                          tooltip: 'Zahl entfernen',
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      number.toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          
                          if (_currentNumbers.length < widget.system.picksNeeded)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: OutlinedButton(
                                onPressed: _addCustomNumber,
                                child: const Text('Eigene Zahl hinzufügen'),
                              ),
                            ),
                          
                          const SizedBox(height: 20),
                          Text(
                            _currentNumbers.join(' - '),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          
                          if (_analysis != null) ...[
                            const SizedBox(height: 30),
                            const Divider(),
                            Text(
                              '📊 Analyse deiner Zahlen:',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Text(
                                      'Treffer in der Vergangenheit:',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${_analysis!['totalMatches']} von ${_analysis!['matchHistory'].length} Ziehungen',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    if (_analysis!['bestMatch']['matchedNumbers'] > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          'Bester Treffer: ${_analysis!['bestMatch']['matchedNumbers']} Zahlen (${_analysis!['bestMatch']['date']})',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    if (_analysis!['wouldHaveWon'])
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          '🎉 Hättest ${_analysis!['winningRounds']}x gewonnen!',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 20),
                          Text(
                            'Viel Glück! 🍀',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
