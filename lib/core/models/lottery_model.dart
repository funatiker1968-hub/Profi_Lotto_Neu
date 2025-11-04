class LotterySystem {
  final String id;
  final String name;
  final int minNumber;
  final int maxNumber;
  final int picksNeeded;
  final int bonusMinNumber;
  final int bonusMaxNumber;
  final int bonusPicksNeeded;
  final String bonusName;

  const LotterySystem({
    required this.id,
    required this.name,
    required this.minNumber,
    required this.maxNumber,
    required this.picksNeeded,
    this.bonusMinNumber = 0,
    this.bonusMaxNumber = 0,
    this.bonusPicksNeeded = 0,
    this.bonusName = '',
  });
}

class LotteryTip {
  final List<int> numbers;
  final List<int> bonusNumbers;
  final LotterySystem system;
  final DateTime generatedAt;

  LotteryTip({
    required this.numbers,
    required this.bonusNumbers,
    required this.system,
    required this.generatedAt,
  });
}

class LotteryDraw {
  final LotterySystem system;
  final List<int> numbers;
  final List<int> bonusNumbers;
  final DateTime drawDate;
  final String jackpot;
  final String nextDrawDate;

  LotteryDraw({
    required this.system,
    required this.numbers,
    required this.bonusNumbers,
    required this.drawDate,
    required this.jackpot,
    required this.nextDrawDate,
  });
}
