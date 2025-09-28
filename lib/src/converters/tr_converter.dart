import 'package:amount_to_word/amount_to_word.dart';

/// Turkish number to words converter
class TrConverter extends ConverterBase {
  @override
  Language get language => Language.tr;

  @override
  String get conjunctionWord => 've';

  static const Map<int, String> _ones = {
    0: 'sıfır',
    1: 'bir',
    2: 'iki',
    3: 'üç',
    4: 'dört',
    5: 'beş',
    6: 'altı',
    7: 'yedi',
    8: 'sekiz',
    9: 'dokuz',
  };

  static const Map<int, String> _teens = {
    10: 'on',
    11: 'on bir',
    12: 'on iki',
    13: 'on üç',
    14: 'on dört',
    15: 'on beş',
    16: 'on altı',
    17: 'on yedi',
    18: 'on sekiz',
    19: 'on dokuz',
  };

  static const Map<int, String> _tens = {
    20: 'yirmi',
    30: 'otuz',
    40: 'kırk',
    50: 'elli',
    60: 'altmış',
    70: 'yetmiş',
    80: 'seksen',
    90: 'doksan',
  };

  static const Map<int, String> _hundreds = {
    100: 'yüz',
    200: 'iki yüz',
    300: 'üç yüz',
    400: 'dört yüz',
    500: 'beş yüz',
    600: 'altı yüz',
    700: 'yedi yüz',
    800: 'sekiz yüz',
    900: 'dokuz yüz',
  };

  static const List<String> _scales = [
    '', // units
    'bin',
    'milyon',
    'milyar',
    'trilyon',
    'katrilyon',
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

    // Main unit - Turkish
    final mainUnit = currency.getMainUnit(Language.tr, count: integerPart);
    if (integerPart > 0) {
      result = '${integerToWords(integerPart)} $mainUnit';
    }

    // Sub unit - only if currency has subUnit
    if (decimalPart != null && decimalPart.isNotEmpty) {
      final decimalValue = int.parse(decimalPart.padRight(2, '0'));
      if (decimalValue > 0) {
        final subUnit = currency.getSubUnit(Language.tr, count: decimalValue);
        if (subUnit != null) {
          final decimalWords = integerToWords(decimalValue);
          if (result.isNotEmpty) {
            result += ' $conjunctionWord ';
          }
          result += '$decimalWords $subUnit';
        }
      }
    }

    return result.isEmpty ? 'sıfır ${currency.getMainUnit(Language.tr, count: 0)}' : result;
  }

  @override
  String integerToWords(int number) {
    if (number == 0) return _ones[0]!;
    if (number < 0) throw ArgumentError('Negative numbers are not supported');

    return _convertInteger(number);
  }

  String _convertInteger(int number) {
    if (number == 0) return '';

    // Sayıyı üçlü gruplara böl
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
        // Türkçe'de "bir bin" değil "bin" deriz
        if (group == 1 && i == 1) {
          words.add(_scales[i]);
        } else {
          words.add('$groupWords ${_scales[i]}');
        }
      } else {
        words.add(groupWords);
      }
    }

    return words.join(' ');
  }

  String _convertThreeDigits(int number) {
    if (number == 0) return '';
    if (number > 999) throw ArgumentError('Number must be less than 1000');

    final words = <String>[];

    // Yüzler
    final hundreds = number ~/ 100;
    if (hundreds > 0) {
      if (hundreds == 1) {
        words.add('yüz'); // "bir yüz" değil "yüz"
      } else {
        words.add(_hundreds[hundreds * 100]!);
      }
    }

    // Kalan (onlar ve birler)
    final remainder = number % 100;

    if (remainder >= 10 && remainder <= 19) {
      // 10-19 arası sayılar
      words.add(_teens[remainder]!);
    } else {
      // Onlar
      final tens = remainder ~/ 10;
      if (tens > 0) {
        words.add(_tens[tens * 10]!);
      }

      // Birler
      final ones = remainder % 10;
      if (ones > 0) {
        words.add(_ones[ones]!);
      }
    }

    return words.join(' ');
  }

  @override
  String decimalToWords(String decimalPart) {
    if (decimalPart.isEmpty) return '';

    // Ondalık kısmı tamsayıya çevir
    final paddedDecimal = decimalPart.padRight(2, '0').substring(0, 2);
    final decimalValue = int.parse(paddedDecimal);

    if (decimalValue == 0) return '';

    final words = integerToWords(decimalValue);
    
    // Ondalık birimini belirle
    String unit;
    switch (decimalPart.length) {
      case 1:
        unit = decimalValue == 1 ? 'onda' : 'onda';
        break;
      case 2:
        unit = decimalValue == 1 ? 'yüzde' : 'yüzde';
        break;
      default:
        unit = 'yüzde';
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
