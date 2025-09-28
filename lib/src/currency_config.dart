import 'language_enum.dart';

/// Configuration for currency units with multi-language support
class CurrencyConfig {
  /// Map of main currency units for each language
  final Map<Language, String> mainUnits;
  
  /// Map of sub currency units for each language - null if currency doesn't use decimals
  final Map<Language, String>? subUnits;
  
  /// Number of sub units in main unit (default: 100)
  final int subUnitInMainUnit;

  const CurrencyConfig({
    required this.mainUnits,
    this.subUnits,
    this.subUnitInMainUnit = 100,
  });

  /// Get main unit for specific language
  String getMainUnit(Language language, {int count = 1}) {
    final unit = mainUnits[language] ?? mainUnits[Language.en] ?? 'unknown';
    return _applyPluralization(unit, count, language);
  }

  /// Get sub unit for specific language  
  String? getSubUnit(Language language, {int count = 1}) {
    if (subUnits == null) return null;
    final unit = subUnits![language] ?? subUnits![Language.en];
    if (unit == null) return null;
    return _applyPluralization(unit, count, language);
  }

  /// Apply pluralization rules based on language and count
  String _applyPluralization(String unit, int count, Language language) {
    switch (language) {
      case Language.en:
        return _englishPluralization(unit, count);
      case Language.tr:
        return _turkishPluralization(unit, count);
      case Language.fa:
        return unit; // Persian generally doesn't pluralize currency units
    }
  }

  /// English pluralization rules
  String _englishPluralization(String unit, int count) {
    if (count == 1) return unit;
    
    // English pluralization rules
    if (unit.endsWith('y')) {
      return '${unit.substring(0, unit.length - 1)}ies'; // penny -> pennies
    } else if (unit.endsWith('s') || unit.endsWith('sh') || unit.endsWith('ch') || unit.endsWith('x') || unit.endsWith('z')) {
      return '${unit}es'; // lira -> liras (but this is rare)
    } else {
      return '${unit}s'; // dollar -> dollars, cent -> cents
    }
  }

  /// Turkish pluralization (generally no change needed for currency units)
  String _turkishPluralization(String unit, int count) {
    // Turkish generally doesn't add plural for currency units
    return unit;
  }

  /// Get main unit by language code
  String getMainUnitByCode(String languageCode, {int count = 1}) {
    final language = Language.fromCode(languageCode) ?? Language.en;
    return getMainUnit(language, count: count);
  }

  /// Get sub unit by language code
  String? getSubUnitByCode(String languageCode, {int count = 1}) {
    final language = Language.fromCode(languageCode) ?? Language.en;
    return getSubUnit(language, count: count);
  }

  // Backward compatibility - deprecated getters
  @Deprecated('Use getMainUnit(Language.fa) instead')
  String get mainUnit => getMainUnit(Language.fa);

  @Deprecated('Use getSubUnit(Language.fa) instead')
  String? get subUnit => getSubUnit(Language.fa);

  /// Currency configurations based on app's predefined currencies
  
  // Iranian Rial (Currency.rial) - no decimals
  static const iranianRial = CurrencyConfig(
    mainUnits: {
      Language.fa: 'ریال',
      Language.en: 'rial',
      Language.tr: 'rial',
    },
    // subUnits: null (no decimals)
  );
  
  // Iranian Toman (Currency.toman) - no decimals
  static const iranianToman = CurrencyConfig(
    mainUnits: {
      Language.fa: 'تومان',
      Language.en: 'toman',
      Language.tr: 'toman',
    },
    // subUnits: null (no decimals)
  );

  // US Dollar (Currency.dollar)
  static const usDollar = CurrencyConfig(
    mainUnits: {
      Language.fa: 'دلار',
      Language.en: 'dollar',
      Language.tr: 'dolar',
    },
    subUnits: {
      Language.fa: 'سنت',
      Language.en: 'cent',
      Language.tr: 'sent',
    },
    subUnitInMainUnit: 100,
  );

  // Euro (Currency.euro)
  static const euro = CurrencyConfig(
    mainUnits: {
      Language.fa: 'یورو',
      Language.en: 'euro',
      Language.tr: 'euro',
    },
    subUnits: {
      Language.fa: 'سنت',
      Language.en: 'cent',
      Language.tr: 'sent',
    },
    subUnitInMainUnit: 100,
  );

  // Canadian Dollar (Currency.cad)
  static const canadianDollar = CurrencyConfig(
    mainUnits: {
      Language.fa: 'دلار کانادا',
      Language.en: 'canadian dollar',
      Language.tr: 'kanada doları',
    },
    subUnits: {
      Language.fa: 'سنت',
      Language.en: 'cent',
      Language.tr: 'sent',
    },
    subUnitInMainUnit: 100,
  );

  // Turkish Lira (Currency.lira)
  static const turkishLira = CurrencyConfig(
    mainUnits: {
      Language.fa: 'لیر',
      Language.en: 'lira',
      Language.tr: 'lira',
    },
    subUnits: {
      Language.fa: 'قروش',
      Language.en: 'kurus',
      Language.tr: 'kuruş',
    },
    subUnitInMainUnit: 100,
  );

  // Afghan Afghani (Currency.afghani) - no decimals
  static const afghanAfghani = CurrencyConfig(
    mainUnits: {
      Language.fa: 'افغانی',
      Language.en: 'afghani',
      Language.tr: 'afgani',
    },
    // subUnits: null (no decimals)
  );

  // Backward compatibility (deprecated)
  @Deprecated('Use iranianToman instead')
  static const tomanRial = iranianToman;
  
  @Deprecated('Use usDollar instead')
  static const dollarCent = usDollar;
  
  @Deprecated('Use euro instead')
  static const euroCent = euro;

  /// Get all available currency configurations (based on app's currencies)
  static List<CurrencyConfig> getAllCurrencies() {
    return [
      iranianRial,
      iranianToman,
      usDollar,
      euro,
      canadianDollar,
      turkishLira,
      afghanAfghani,
    ];
  }

  /// Get currency by app's Currency enum
  static CurrencyConfig getByAppCurrency(dynamic appCurrency) {
    // This assumes the parameter is from Currency enum
    final currencyName = appCurrency.toString().split('.').last;
    
    switch (currencyName) {
      case 'rial':
        return iranianRial;
      case 'toman':
        return iranianToman;
      case 'dollar':
        return usDollar;
      case 'euro':
        return euro;
      case 'cad':
        return canadianDollar;
      case 'lira':
        return turkishLira;
      case 'afghani':
        return afghanAfghani;
      default:
        return iranianToman; // fallback
    }
  }

  /// Get currency by country/region name
  static CurrencyConfig? getByCountry(String countryName) {
    final country = countryName.toLowerCase().trim();
    
    if (country.contains('ایران') || country.contains('iran')) {
      return iranianToman; // Default Iranian currency
    }
    if (country.contains('آمریکا') || country.contains('america') || country.contains('usa')) {
      return usDollar;
    }
    if (country.contains('اروپا') || country.contains('europe')) {
      return euro;
    }
    if (country.contains('کانادا') || country.contains('canada')) {
      return canadianDollar;
    }
    if (country.contains('ترکیه') || country.contains('turkey')) {
      return turkishLira;
    }
    if (country.contains('افغانستان') || country.contains('afghanistan')) {
      return afghanAfghani;
    }
    
    return null;
  }

  /// Check if this currency supports decimal/fractional amounts
  bool get hasSubUnit => subUnits != null;

  /// Add support for a new language easily
  /// 
  /// Example: Adding Arabic support to USD
  /// ```dart
  /// final usdWithArabic = CurrencyConfig.usDollar.addLanguage(
  ///   Language.ar, 
  ///   'dollar', 
  ///   'cent'
  /// );
  /// ```
  CurrencyConfig addLanguage(Language language, String mainUnit, [String? subUnit]) {
    final newMainUnits = Map<Language, String>.from(mainUnits);
    newMainUnits[language] = mainUnit;

    Map<Language, String>? newSubUnits;
    if (subUnits != null || subUnit != null) {
      newSubUnits = Map<Language, String>.from(subUnits ?? {});
      if (subUnit != null) {
        newSubUnits[language] = subUnit;
      }
    }

    return CurrencyConfig(
      mainUnits: newMainUnits,
      subUnits: newSubUnits,
      subUnitInMainUnit: subUnitInMainUnit,
    );
  }

  @override
  String toString() {
    final mainUnitsStr = mainUnits.entries.map((e) => '${e.key.code}:${e.value}').join(', ');
    if (hasSubUnit) {
      final subUnitsStr = subUnits!.entries.map((e) => '${e.key.code}:${e.value}').join(', ');
      return 'CurrencyConfig(mainUnits: {$mainUnitsStr}, subUnits: {$subUnitsStr}, ratio: $subUnitInMainUnit)';
    } else {
      return 'CurrencyConfig(mainUnits: {$mainUnitsStr}, no decimals)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurrencyConfig &&
        _mapEquals(other.mainUnits, mainUnits) &&
        _mapEquals(other.subUnits, subUnits) &&
        other.subUnitInMainUnit == subUnitInMainUnit;
  }

  @override
  int get hashCode {
    return mainUnits.hashCode ^ subUnits.hashCode ^ subUnitInMainUnit.hashCode;
  }

  // Helper method for comparing maps
  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }
}