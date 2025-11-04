import 'dart:math';
import '../models/lottery_model.dart';

class LotteryService {
  final List<LotterySystem> systems = const [
    LotterySystem(
      id: '6aus49',
      name: '6aus49',
      minNumber: 1,
      maxNumber: 49,
      picksNeeded: 6,
    ),
    LotterySystem(
      id: 'eurojackpot',
      name: 'Eurojackpot', 
      minNumber: 1,
      maxNumber: 50,
      picksNeeded: 5,
    ),
    LotterySystem(
      id: 'sayisal_loto',
      name: 'Sayısal Loto',
      minNumber: 1,
      maxNumber: 90,
      picksNeeded: 6,
    ),
  ];

  List<int> generateTip(LotterySystem system) {
    return _generateRandomNumbers(system.minNumber, system.maxNumber, system.picksNeeded);
  }

  List<int> generateCustomTip({
    required LotterySystem system,
    List<int>? favoriteNumbers,
    List<int>? excludedNumbers,
    bool preferHotNumbers = false,
    int minRange = 1,
    int maxRange = 0,
  }) {
    final effectiveMin = minRange > 0 ? minRange : system.minNumber;
    final effectiveMax = maxRange > 0 ? maxRange : system.maxNumber;
    
    List<int> numbers = [];
    final random = Random();
    
    if (favoriteNumbers != null && favoriteNumbers.isNotEmpty) {
      final validFavorites = favoriteNumbers
          .where((number) => number >= effectiveMin && number <= effectiveMax)
          .where((number) => !(excludedNumbers?.contains(number) ?? false))
          .toList();
      
      if (validFavorites.isNotEmpty) {
        final favoritesToUse = validFavorites.take(system.picksNeeded ~/ 2).toList();
        numbers.addAll(favoritesToUse);
      }
    }
    
    while (numbers.length < system.picksNeeded) {
      final number = random.nextInt(effectiveMax - effectiveMin + 1) + effectiveMin;
      
      if (excludedNumbers?.contains(number) ?? false) {
        continue;
      }
      
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
      
      if (numbers.length < system.picksNeeded && numbers.length == numbers.toSet().length) {
        final remaining = system.picksNeeded - numbers.length;
        final availableNumbers = List.generate(
          effectiveMax - effectiveMin + 1, 
          (i) => i + effectiveMin
        ).where((number) => 
          !numbers.contains(number) && 
          !(excludedNumbers?.contains(number) ?? false)
        ).toList();
        
        if (availableNumbers.length >= remaining) {
          availableNumbers.shuffle();
          numbers.addAll(availableNumbers.take(remaining));
        }
      }
    }
    
    numbers.sort();
    return numbers;
  }

  List<int> _generateRandomNumbers(int min, int max, int count) {
    final numbers = <int>[];
    final random = Random();

    while (numbers.length < count) {
      final number = random.nextInt(max - min + 1) + min;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }

    numbers.sort();
    return numbers;
  }
}
