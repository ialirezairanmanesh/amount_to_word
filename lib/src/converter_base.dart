import 'package:amount_to_word/src/language_enum.dart';

import 'currency_config.dart';
import 'number_format.dart';
import 'utils/number_formatter.dart';

/// Base class for number to words converters
abstract class ConverterBase {
  /// Language of this converter
  Language get language;

  /// Convert number to words without currency
  String numberToWords(num number);

  /// Convert amount to words with currency
  String amountToWords(num amount, {CurrencyConfig? currency});

  /// Convert number to mixed format (digits + words)
  /// Example: 2566 -> "۲ هزار و ۵۶۶" (Persian), "2 thousand 566" (English)
  String numberToMixed(num number, {NumberFormatConfig? formatConfig});

  /// Convert amount to mixed format with currency
  String amountToMixed(num amount, {CurrencyConfig? currency, NumberFormatConfig? formatConfig});

  /// Convert integer part to words
  String integerToWords(int number);

  /// Convert decimal part to words
  String decimalToWords(String decimalPart);

  /// Get conjunction word (e.g., 'و' in Persian, 'and' in English)
  String get conjunctionWord;

  /// Validate if number is within supported range
  bool isValidNumber(num number) {
    return number >= 0 && number < 1000000000000000; // Up to quadrillion
  }

  /// Split number into integer and decimal parts
  Map<String, dynamic> splitNumber(num number) {
    final str = number.toString();
    final parts = str.split('.');
    
    final integerPart = int.parse(parts[0]);
    String? decimalPart;
    
    if (parts.length > 1) {
      decimalPart = parts[1];
      // Limit decimal places to avoid very long words
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      
      // If decimal part contains only zeros, set it to null
      if (decimalPart.replaceAll('0', '').isEmpty) {
        decimalPart = null;
      }
    }
    
    return {
      'integer': integerPart,
      'decimal': decimalPart,
    };
  }

  /// Default implementation for mixed format
  /// Can be overridden by specific converters for better optimization
  String numberToMixedDefault(num number, {NumberFormatConfig? formatConfig}) {
    final config = formatConfig ?? NumberFormatConfig.mixed;
    final parts = splitNumber(number);
    final integerPart = parts['integer'] as int;
    final decimalPart = parts['decimal'] as String?;

    // Convert integer part to mixed format
    String result = _integerToMixed(integerPart, config);

    // Add decimal part if exists
    if (decimalPart != null && decimalPart.isNotEmpty) {
      final decimalValue = int.parse(decimalPart);
      if (decimalValue > 0) {
        final decimalWords = decimalToWords(decimalPart);
        if (result.isNotEmpty) {
          result += ' $conjunctionWord $decimalWords';
        } else {
          result = decimalWords;
        }
      }
    }

    return result.isEmpty ? NumberFormatter.toLanguageDigits('0', language) : result;
  }

  /// Convert integer to mixed format (digits + words for large units)
  String _integerToMixed(int number, NumberFormatConfig config) {
    if (number == 0) {
      return NumberFormatter.toLanguageDigits('0', language);
    }

    // Always use mixed format regardless of threshold
    return _createMixedRepresentation(number);
  }

  /// Create mixed representation like "۲ هزار و ۵۶۶"
  String _createMixedRepresentation(int number) {
    final groups = <String>[];
    int tempNumber = number;
    int groupIndex = 0;
    
    final scales = _getScaleWords();
    
    while (tempNumber > 0) {
      final groupValue = tempNumber % 1000;
      tempNumber ~/= 1000;
      
      if (groupValue > 0) {
        String groupStr;
        if (groupIndex == 0) {
          // Units group - always show as digits for mixed format
          groupStr = NumberFormatter.toLanguageDigits(groupValue.toString(), language);
        } else {
          // Higher groups - always show as digits for mixed format
          groupStr = NumberFormatter.toLanguageDigits(groupValue.toString(), language);
          
          if (groupIndex < scales.length) {
            groupStr += ' ${scales[groupIndex]}';
          }
        }
        groups.add(groupStr);
      }
      groupIndex++;
    }
    
    // Reverse and join groups
    if (groups.length > 1) {
      final reversed = groups.reversed.toList();
      // For English and Turkish mixed format, don't use conjunction between major groups
      if (language == Language.en || language == Language.tr) {
        return reversed.join(' ');
      } else {
        // For other languages, use conjunction word
        final result = <String>[];
        for (int i = 0; i < reversed.length; i++) {
          result.add(reversed[i]);
          if (i < reversed.length - 1) {
            result.add(conjunctionWord);
          }
        }
        return result.join(' ');
      }
    } else {
      return groups.first;
    }
  }

  /// Get scale words for current language (thousand, million, etc.)
  List<String> _getScaleWords() {
    switch (language) {
      case Language.fa:
        return ['', 'هزار', 'میلیون', 'میلیارد', 'بیلیون', 'بیلیارد'];
      case Language.en:
        return ['', 'thousand', 'million', 'billion', 'trillion', 'quadrillion'];
      case Language.tr:
        return ['', 'bin', 'milyon', 'milyar', 'trilyon', 'katrilyon'];
    }
  }

  /// Default implementation for amount to mixed format
  String amountToMixedDefault(num amount, {CurrencyConfig? currency, NumberFormatConfig? formatConfig}) {
    if (currency == null) {
      return numberToMixedDefault(amount, formatConfig: formatConfig);
    }

    final parts = splitNumber(amount);
    final integerPart = parts['integer'] as int;
    final decimalPart = parts['decimal'] as String?;

    String result = '';

    // Main unit with mixed format
    final mainUnit = currency.getMainUnit(language, count: integerPart);
    if (integerPart > 0) {
      final mixedAmount = _integerToMixed(integerPart, formatConfig ?? NumberFormatConfig.mixed);
      result = '$mixedAmount $mainUnit';
    }

    // Sub unit if exists
    if (decimalPart != null && decimalPart.isNotEmpty) {
      final decimalValue = int.parse(decimalPart.padRight(2, '0'));
      if (decimalValue > 0) {
        final subUnit = currency.getSubUnit(language, count: decimalValue);
        if (subUnit != null) {
          final mixedDecimal = _integerToMixed(decimalValue, formatConfig ?? NumberFormatConfig.mixed);
          if (result.isNotEmpty) {
            result += ' $conjunctionWord ';
          }
          result += '$mixedDecimal $subUnit';
        }
      }
    }

    return result.isEmpty ? '${NumberFormatter.toLanguageDigits('0', language)} $mainUnit' : result;
  }
}