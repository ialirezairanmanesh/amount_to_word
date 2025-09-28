import 'package:amount_to_word/amount_to_word.dart';

/// English number to words converter
class EnConverter extends ConverterBase {
  @override
  Language get language => Language.en;

  @override
  String get conjunctionWord => 'and';

  static const Map<int, String> _ones = {
    0: 'zero',
    1: 'one',
    2: 'two',
    3: 'three',
    4: 'four',
    5: 'five',
    6: 'six',
    7: 'seven',
    8: 'eight',
    9: 'nine',
  };

  static const Map<int, String> _teens = {
    10: 'ten',
    11: 'eleven',
    12: 'twelve',
    13: 'thirteen',
    14: 'fourteen',
    15: 'fifteen',
    16: 'sixteen',
    17: 'seventeen',
    18: 'eighteen',
    19: 'nineteen',
  };

  static const Map<int, String> _tens = {
    20: 'twenty',
    30: 'thirty',
    40: 'forty',
    50: 'fifty',
    60: 'sixty',
    70: 'seventy',
    80: 'eighty',
    90: 'ninety',
  };

  static const List<String> _scales = [
    '', // units
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
  ];

  @override
  String numberToWords(num number) {
    if (!isValidNumber(number)) {
      throw ArgumentError('Number is out of supported range');
    }

    if (number == 0) return _ones[0]!;

    final parts = splitNumber(number);
    final integerPart = parts['integer'] as int;
    final decimalPart = parts['decimal'] as String?;

    String result = integerToWords(integerPart);

    if (decimalPart != null && decimalPart.isNotEmpty) {
      final decimalWords = decimalToWords(decimalPart);
      if (decimalWords.isNotEmpty) {
        result += ' $conjunctionWord $decimalWords';
      }
    }

    return result;
  }

  @override
  String amountToWords(num amount, {CurrencyConfig? currency}) {
    if (currency == null) {
      return numberToWords(amount);
    }

    final parts = splitNumber(amount);
    final integerPart = parts['integer'] as int;
    final decimalPart = parts['decimal'] as String?;

    String result = '';

    // Main unit - English
    final mainUnit = currency.getMainUnit(Language.en, count: integerPart);
    if (integerPart > 0) {
      result = '${integerToWords(integerPart)} $mainUnit';
    }

    // Sub unit - only if currency has subUnit
    if (decimalPart != null && decimalPart.isNotEmpty) {
      final decimalValue = int.parse(decimalPart.padRight(2, '0'));
      if (decimalValue > 0) {
        final subUnit = currency.getSubUnit(Language.en, count: decimalValue);
        if (subUnit != null) {
          final decimalWords = integerToWords(decimalValue);
          if (result.isNotEmpty) {
            result += ' $conjunctionWord ';
          }
          result += '$decimalWords $subUnit';
        }
      }
    }

    return result.isEmpty ? 'zero ${currency.getMainUnit(Language.en, count: 0)}' : result;
  }

  @override
  String integerToWords(int number) {
    if (number == 0) return _ones[0]!;
    if (number < 0) throw ArgumentError('Negative numbers are not supported');

    return _convertInteger(number);
  }

  String _convertInteger(int number) {
    if (number == 0) return '';

    // Split into groups of three digits
    final groups = <int>[];
    int temp = number;

    while (temp > 0) {
      groups.add(temp % 1000);
      temp ~/= 1000;
    }

    final words = <String>[];

    for (int i = groups.length - 1; i >= 0; i--) {
      final group = groups[i];
      if (group == 0) continue;

      final groupWords = _convertThreeDigits(group);

      if (i > 0 && i < _scales.length) {
        final withScale = '$groupWords ${_scales[i]}';
        words.add(withScale);
      } else {
        words.add(groupWords);
      }
    }

    final result = words.join(' ');
    return result;
  }

  String _convertThreeDigits(int number) {
    if (number == 0) return '';
    if (number > 999) throw ArgumentError('Number must be less than 1000');

    final words = <String>[];

    // Hundreds
    final hundreds = number ~/ 100;
    if (hundreds > 0) {
      words.add('${_ones[hundreds]} hundred');
    }

    // Remainder (tens and ones)
    final remainder = number % 100;

    if (remainder >= 10 && remainder <= 19) {
      // Numbers 10-19
      words.add(_teens[remainder]!);
    } else {
      // Tens
      final tens = remainder ~/ 10;
      if (tens > 0) {
        final ones = remainder % 10;
        if (ones > 0) {
          words.add('${_tens[tens * 10]}-${_ones[ones]}');
        } else {
          words.add(_tens[tens * 10]!);
        }
      } else {
        // Only ones
        final ones = remainder % 10;
        if (ones > 0) {
          words.add(_ones[ones]!);
        }
      }
    }

    return words.join(' ');
  }

  @override
  String decimalToWords(String decimalPart) {
    if (decimalPart.isEmpty) return '';

    // Convert decimal part to integer
    final paddedDecimal = decimalPart.padRight(2, '0').substring(0, 2);
    final decimalValue = int.parse(paddedDecimal);

    if (decimalValue == 0) return '';

    final words = integerToWords(decimalValue);

    // Determine decimal unit based on number of digits
    String unit;
    switch (decimalPart.length) {
      case 1:
        unit = decimalValue == 1 ? 'tenth' : 'tenths';
        break;
      case 2:
        unit = decimalValue == 1 ? 'hundredth' : 'hundredths';
        break;
      default:
        unit = decimalValue == 1 ? 'hundredth' : 'hundredths';
    }

    return '$words $unit';
  }

  @override
  String numberToMixed(num number, {NumberFormatConfig? formatConfig}) {
    return numberToMixedDefault(number, formatConfig: formatConfig);
  }

  @override
  String amountToMixed(num amount, {CurrencyConfig? currency, NumberFormatConfig? formatConfig}) {
    return amountToMixedDefault(amount, currency: currency, formatConfig: formatConfig);
  }
}
