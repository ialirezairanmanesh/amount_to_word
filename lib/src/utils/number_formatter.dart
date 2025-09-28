
import 'package:amount_to_word/amount_to_word.dart';

/// Utility class for number formatting and digit conversion
class NumberFormatter {
  // Persian digit mappings
  static const Map<String, String> _persianDigits = {
    '0': '۰',
    '1': '۱',
    '2': '۲',
    '3': '۳',
    '4': '۴',
    '5': '۵',
    '6': '۶',
    '7': '۷',
    '8': '۸',
    '9': '۹',
  };

  // Arabic digit mappings
  static const Map<String, String> _arabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  /// Convert Latin digits to Persian digits
  static String toPersianDigits(String input) {
    String result = input;
    _persianDigits.forEach((latin, persian) {
      result = result.replaceAll(latin, persian);
    });
    return result;
  }

  /// Convert Latin digits to Arabic digits
  static String toArabicDigits(String input) {
    String result = input;
    _arabicDigits.forEach((latin, arabic) {
      result = result.replaceAll(latin, arabic);
    });
    return result;
  }

  /// Convert Persian or Arabic digits to Latin digits
  static String toLatinDigits(String input) {
    String result = input;
    
    // Convert Persian digits
    _persianDigits.forEach((latin, persian) {
      result = result.replaceAll(persian, latin);
    });
    
    // Convert Arabic digits
    _arabicDigits.forEach((latin, arabic) {
      result = result.replaceAll(arabic, latin);
    });
    
    return result;
  }

  /// Check if string contains Persian digits
  static bool containsPersianDigits(String input) {
    return _persianDigits.values.any(input.contains);
  }

  /// Check if string contains Arabic digits
  static bool containsArabicDigits(String input) {
    return _arabicDigits.values.any(input.contains);
  }

  /// Check if string contains non-English digits
  static bool containsNonEnglishDigits(String input) {
    return containsPersianDigits(input) || containsArabicDigits(input);
  }

  /// Convert digits to language-specific format
  static String toLanguageDigits(String input, Language language) {
    switch (language) {
      case Language.fa:
        return toPersianDigits(input);
      case Language.en:
      case Language.tr:
        return input; // Keep Latin digits
    }
  }

  /// Format number with language-specific digits and optional commas
  static String formatLanguageNumber(
    num number, 
    Language language, {
    bool addCommas = false,
  }) {
    String numberStr = number.toString();
    
    if (addCommas) {
      numberStr = addCommasToNumber(numberStr);
    }
    
    return toLanguageDigits(numberStr, language);
  }

  /// Add commas to number string for thousands separation
  static String addCommasToNumber(String numberStr) {
    // Handle decimal part
    final parts = numberStr.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;
    
    // Add commas to integer part
    String result = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        result += ',';
      }
      result += integerPart[i];
    }
    
    // Add decimal part back if exists
    if (decimalPart != null) {
      result += '.$decimalPart';
    }
    
    return result;
  }
}

