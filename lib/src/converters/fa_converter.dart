import 'package:amount_to_word/amount_to_word.dart';

/// Persian number to words converter
class FaConverter extends ConverterBase {
  @override
  Language get language => Language.fa;

  @override
  String get conjunctionWord => 'و';

  // Basic number definitions
  static const Map<int, String> _ones = {
    0: 'صفر',
    1: 'یک',
    2: 'دو',
    3: 'سه',
    4: 'چهار',
    5: 'پنج',
    6: 'شش',
    7: 'هفت',
    8: 'هشت',
    9: 'نه',
  };

  static const Map<int, String> _teens = {
    10: 'ده',
    11: 'یازده',
    12: 'دوازده',
    13: 'سیزده',
    14: 'چهارده',
    15: 'پانزده',
    16: 'شانزده',
    17: 'هفده',
    18: 'هجده',
    19: 'نوزده',
  };

  static const Map<int, String> _tens = {
    20: 'بیست',
    30: 'سی',
    40: 'چهل',
    50: 'پنجاه',
    60: 'شصت',
    70: 'هفتاد',
    80: 'هشتاد',
    90: 'نود',
  };

  static const Map<int, String> _hundreds = {
    100: 'صد',
    200: 'دویست',
    300: 'سیصد',
    400: 'چهارصد',
    500: 'پانصد',
    600: 'ششصد',
    700: 'هفتصد',
    800: 'هشتصد',
    900: 'نهصد',
  };

  static const List<String> _scales = [
    '', // units
    'هزار', // thousand
    'میلیون', // million
    'میلیارد', // billion
    'بیلیون', // trillion
    'بیلیارد', // quadrillion
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

    // Main unit - Persian
    final mainUnit = currency.getMainUnit(Language.fa, count: integerPart);
    if (integerPart > 0) {
      result = '${integerToWords(integerPart)} $mainUnit';
    }

    // Sub unit - only if currency has subUnit
    if (decimalPart != null && decimalPart.isNotEmpty) {
      final decimalValue = int.parse(decimalPart.padRight(2, '0'));
      if (decimalValue > 0) {
        final subUnit = currency.getSubUnit(Language.fa, count: decimalValue);
        if (subUnit != null) {
          final decimalWords = integerToWords(decimalValue);
          if (result.isNotEmpty) {
            result += ' $conjunctionWord ';
          }
          result += '$decimalWords $subUnit';
        }
      }
    }

    return result.isEmpty ? 'صفر ${currency.getMainUnit(Language.fa, count: 0)}' : result;
  }

  @override
  String integerToWords(int number) {
    if (number == 0) return _ones[0]!;
    if (number < 0) throw ArgumentError('Negative numbers are not supported');

    return _convertInteger(number);
  }

  String _convertInteger(int number) {
    if (number == 0) return '';

    // Split number into groups of three digits
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

    // Add "و" between groups (but not at the end)
    String result;
    if (words.length > 1) {
      // Add "و" between groups
      final resultParts = <String>[];
      for (int i = 0; i < words.length; i++) {
        resultParts.add(words[i]);
        if (i < words.length - 1) {
          resultParts.add(conjunctionWord);
        }
      }
      result = resultParts.join(' ');
    } else {
      result = words.join(' ');
    }
    
    return result;
  }

  String _convertThreeDigits(int number) {
    if (number == 0) return '';
    if (number > 999) throw ArgumentError('Number must be less than 1000');

    final words = <String>[];

    // Hundreds
    final hundreds = number ~/ 100;
    if (hundreds > 0) {
      words.add(_hundreds[hundreds * 100]!);
    }

    // Remainder (tens and ones)
    final remainder = number % 100;

    if (remainder >= 10 && remainder <= 19) {
      // Numbers 10-19 - these are single words, no "و" needed
      words.add(_teens[remainder]!);
    } else {
      // Tens
      final tens = remainder ~/ 10;
      if (tens > 0) {
        words.add(_tens[tens * 10]!);
      }

      // Ones
      final ones = remainder % 10;
      if (ones > 0) {
        words.add(_ones[ones]!);
      }
    }

    // Combine words with "و" between different parts
    if (words.length > 1) {
      final result = <String>[];
      for (int i = 0; i < words.length; i++) {
        result.add(words[i]);
        if (i < words.length - 1) {
          result.add(conjunctionWord);
        }
      }
      return result.join(' ');
    } else {
      return words.join(' ');
    }
  }

  @override
  String decimalToWords(String decimalPart) {
    if (decimalPart.isEmpty) return '';

    // Convert decimal part to integer
    final decimalValue = int.parse(decimalPart);

    if (decimalValue == 0) return '';

    final words = integerToWords(decimalValue);

    // Determine decimal unit based on number of digits
    String unit;
    switch (decimalPart.length) {
      case 1:
        unit = 'دهم';
        break;
      case 2:
        unit = 'صدم';
        break;
      default:
        unit = 'صدم'; // limited to two decimal places
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
