import 'package:amount_to_word/src/language_enum.dart';
import 'package:flutter/material.dart';

import 'converter_base.dart';
import 'currency_config.dart';
import 'number_format.dart';
import 'converters/fa_converter.dart';
import 'converters/en_converter.dart';
import 'converters/tr_converter.dart';

/// Main class for converting amounts to words
class AmountToWords {
  late final ConverterBase _converter;
  final Language _language;

  /// Create converter for specific language
  AmountToWords(Language language) : _language = language {
    _converter = _createConverter(language);
  }

  /// Create converter with auto-detected language from locale
  /// Falls back to English if locale is not supported
  AmountToWords.fromLocale([String? localeCode]) : _language = _detectLanguage(localeCode) {
    _converter = _createConverter(_language);
  }

  /// Create converter from BuildContext (for l10n integration)
  /// Automatically detects language from current locale
  AmountToWords.fromContext(BuildContext context) : _language = _detectLanguageFromContext(context) {
    _converter = _createConverter(_language);
  }

  /// Get the current language
  Language get language => _language;

  /// Convert number to words without currency
  String toWords(num number) {
    return _converter.numberToWords(number);
  }

  /// Convert amount to words with currency
  String convert(num amount, {CurrencyConfig? currency}) {
    return _converter.amountToWords(amount, currency: currency);
  }

  /// Convert number to mixed format (digits + words)
  /// Example: 2566 -> "۲ هزار و ۵۶۶" (Persian), "2 thousand 566" (English)
  String toMixed(num number, {NumberFormatConfig? formatConfig}) {
    return _converter.numberToMixed(number, formatConfig: formatConfig);
  }

  /// Convert amount to mixed format with currency
  /// Example: 2566.5 USD -> "۲ هزار و ۵۶۶ دلار و ۵۰ سنت" (Persian)
  String convertToMixed(num amount, {CurrencyConfig? currency, NumberFormatConfig? formatConfig}) {
    return _converter.amountToMixed(amount, currency: currency, formatConfig: formatConfig);
  }

  /// Convert integer to words
  String integerToWords(int number) {
    return _converter.integerToWords(number);
  }

  /// Get conjunction word for current language
  String get conjunctionWord => _converter.conjunctionWord;

  /// Check if number is in valid range
  bool isValidNumber(num number) {
    return _converter.isValidNumber(number);
  }

  // Private methods

  static ConverterBase _createConverter(Language language) {
    switch (language) {
      case Language.fa:
        return FaConverter();
      case Language.en:
        return EnConverter();
      case Language.tr:
        return TrConverter();
    }
  }

  static Language _detectLanguage([String? localeCode]) {
    if (localeCode != null) {
      final language = Language.fromCode(localeCode);
      if (language != null) return language;
    }

    // Try to get from current locale (requires intl package in real app)
    // For now, return English as default
    return Language.en;
  }

  static Language _detectLanguageFromContext(BuildContext context) {
    // Get locale from context
    final locale = Localizations.localeOf(context);
    
    // Try to detect language from locale
    final language = Language.fromCode(locale.languageCode);
    if (language != null) return language;
    
    // Fallback to English if not supported
    return Language.en;
  }

  /// Create converter instances for all supported languages
  static Map<Language, AmountToWords> createAll() {
    return {
      for (final lang in Language.values) lang: AmountToWords(lang)
    };
  }

  /// Create converter from BuildContext (static method for convenience)
  static AmountToWords of(BuildContext context) {
    return AmountToWords.fromContext(context);
  }

  /// Convert number to words using context (convenience method)
  static String convertWithContext(BuildContext context, num number, {CurrencyConfig? currency}) {
    final converter = AmountToWords.fromContext(context);
    return currency != null ? converter.convert(number, currency: currency) : converter.toWords(number);
  }

  @override
  String toString() {
    return 'AmountToWords(${_language.name})';
  }
}