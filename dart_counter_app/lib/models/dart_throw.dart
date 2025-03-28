class DartThrow {
  final int value;
  final int multiplier;

  DartThrow({required this.value, required this.multiplier});

  String get display {
    if (value == 0) return '0';
    int base = value ~/ multiplier;
    String prefix = '';
    switch (multiplier) {
      case 2:
        prefix = 'D';
        break;
      case 3:
        prefix = 'T';
        break;
    }
    return '$prefix$base';
  }
}
