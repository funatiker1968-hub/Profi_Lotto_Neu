class LotterySystem {
  final String id;
  final String name;
  final int minNumber;
  final int maxNumber;
  final int picksNeeded;

  const LotterySystem({
    required this.id,
    required this.name,
    required this.minNumber,
    required this.maxNumber,
    required this.picksNeeded,
  });
}

class LotteryTip {
  final List<int> numbers;
  final LotterySystem system;
  final DateTime generatedAt;

  LotteryTip({
    required this.numbers,
    required this.system,
    required this.generatedAt,
  });
}
