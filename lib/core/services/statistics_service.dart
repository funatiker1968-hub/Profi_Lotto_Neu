import '../models/lottery_model.dart';

class StatisticsService {
  final Map<String, List<Map<String, dynamic>>> _historicalData = {
    '6aus49': [
      {'numbers': [3, 15, 22, 31, 42, 49], 'date': '2024-01-01', 'superzahl': 5},
      {'numbers': [5, 12, 19, 27, 35, 44], 'date': '2024-01-08', 'superzahl': 2},
      {'numbers': [8, 14, 21, 29, 36, 45], 'date': '2024-01-15', 'superzahl': 8},
      {'numbers': [1, 11, 21, 31, 41, 49], 'date': '2024-01-22', 'superzahl': 3},
      {'numbers': [7, 17, 27, 37, 42, 48], 'date': '2024-01-29', 'superzahl': 1},
    ],
    'eurojackpot': [
      {'numbers': [2, 11, 18, 25, 33], 'euroNumbers': [3, 8], 'date': '2024-01-02'},
      {'numbers': [4, 13, 20, 28, 37], 'euroNumbers': [2, 9], 'date': '2024-01-09'},
      {'numbers': [1, 9, 19, 29, 39], 'euroNumbers': [4, 7], 'date': '2024-01-16'},
    ],
    'sayisal_loto': [
      {'numbers': [7, 15, 23, 34, 42, 56], 'date': '2024-01-03'},
      {'numbers': [9, 18, 26, 38, 47, 61], 'date': '2024-01-10'},
      {'numbers': [3, 12, 25, 39, 51, 67], 'date': '2024-01-17'},
    ],
  };

  Map<String, dynamic> getHotColdNumbers(LotterySystem system) {
    final draws = _historicalData[system.id] ?? [];
    final numberCount = <int, int>{};
    
    for (final draw in draws) {
      for (final number in draw['numbers']) {
        numberCount[number] = (numberCount[number] ?? 0) + 1;
      }
    }
    
    final sortedNumbers = numberCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final hotNumbers = sortedNumbers.take(6).map((e) => e.key).toList();
    final coldNumbers = sortedNumbers.reversed.take(6).map((e) => e.key).toList();
    
    return {
      'hotNumbers': hotNumbers,
      'coldNumbers': coldNumbers,
      'totalDraws': draws.length,
      'lastUpdate': '2024-01-29',
    };
  }

  Map<String, dynamic> analyzeNumbers(List<int> userNumbers, LotterySystem system) {
    final draws = _historicalData[system.id] ?? [];
    final analysis = <String, dynamic>{
      'totalMatches': 0,
      'bestMatch': <String, dynamic>{'date': '', 'matchedNumbers': 0, 'numbers': [], 'superzahl': null},
      'matchHistory': <Map<String, dynamic>>[],
      'wouldHaveWon': false,
      'winningRounds': 0,
    };

    for (final draw in draws) {
      final drawNumbers = List<int>.from(draw['numbers']);
      final matchedNumbers = userNumbers.where((userNumber) => drawNumbers.contains(userNumber)).length;
      
      if (matchedNumbers > 0) {
        analysis['totalMatches'] = (analysis['totalMatches'] as int) + 1;
        
        final bestMatch = analysis['bestMatch'] as Map<String, dynamic>;
        if (matchedNumbers > (bestMatch['matchedNumbers'] as int)) {
          analysis['bestMatch'] = {
            'date': draw['date'],
            'matchedNumbers': matchedNumbers,
            'numbers': drawNumbers,
            'superzahl': draw['superzahl'],
          };
        }

        if (matchedNumbers >= (system.picksNeeded == 6 ? 3 : 2)) {
          analysis['wouldHaveWon'] = true;
          analysis['winningRounds'] = (analysis['winningRounds'] as int) + 1;
        }

        (analysis['matchHistory'] as List<Map<String, dynamic>>).add({
          'date': draw['date'],
          'matchedNumbers': matchedNumbers,
          'drawNumbers': drawNumbers,
          'userNumbers': userNumbers,
        });
      }
    }

    return analysis;
  }

  List<Map<String, dynamic>> getRecentDraws(LotterySystem system) {
    return _historicalData[system.id] ?? [];
  }

  Map<String, dynamic> getNumberStats(List<int> numbers, LotterySystem system) {
    final draws = _historicalData[system.id] ?? [];
    final stats = <String, dynamic>{
      'timesDrawn': 0,
      'lastDrawn': '',
      'frequency': 0.0,
    };

    for (final draw in draws) {
      final drawNumbers = List<int>.from(draw['numbers']);
      if (numbers.every((number) => drawNumbers.contains(number))) {
        stats['timesDrawn'] = (stats['timesDrawn'] as int) + 1;
        stats['lastDrawn'] = draw['date'];
      }
    }

    stats['frequency'] = draws.isEmpty ? 0.0 : ((stats['timesDrawn'] as int) / draws.length * 100);
    return stats;
  }
}
