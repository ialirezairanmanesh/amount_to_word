# Amount to Words

A comprehensive Flutter package for converting numbers and amounts to words in multiple languages with full currency support.

[![Pub Package](https://img.shields.io/pub/v/amount_to_word.svg)](https://pub.dev/packages/amount_to_word)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- ✅ **Multi-language Support**: Persian (Farsi), English, and Turkish
- ✅ **Currency Integration**: Full support for major currencies with proper pluralization
- ✅ **Multiple Number Formats**: Words, Mixed (digits + words), Language digits, Latin digits
- ✅ **Automatic Localization**: Integrates seamlessly with Flutter's localization system
- ✅ **Extensible Architecture**: Easy to add new languages and currencies
- ✅ **Smart Pluralization**: Handles singular/plural forms correctly for each language
- ✅ **No Dependencies**: Pure Dart implementation with minimal footprint
- ✅ **Comprehensive Testing**: 100% test coverage with edge cases
- ✅ **TypeScript-like Type Safety**: Full null safety support

## Supported Languages

| Language | Code | Number Example | Currency Example |
|----------|------|----------------|------------------|
| Persian  | `fa` | دوازده هزار سیصد چهل پنج | یکصد و بیست سه دلار و چهل پنج سنت |
| English  | `en` | twelve thousand three hundred forty-five | one hundred twenty-three dollars and forty-five cents |
| Turkish  | `tr` | on iki bin üç yüz kırk beş | yüz yirmi üç dolar ve kırk beş sent |

## Supported Currencies

| Currency | Supports Decimals | Persian | English | Turkish |
|----------|-------------------|---------|---------|---------|
| Iranian Rial | ❌ | ریال | rial | rial |
| Iranian Toman | ❌ | تومان | toman | toman |
| US Dollar | ✅ | دلار/سنت | dollar/cent | dolar/sent |
| Euro | ✅ | یورو/سنت | euro/cent | euro/sent |
| Canadian Dollar | ✅ | دلار کانادا/سنت | canadian dollar/cent | kanada doları/sent |
| Turkish Lira | ✅ | لیر/کوروش | lira/kurus | lira/kuruş |
| Afghan Afghani | ❌ | افغانی | afghani | afgani |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  amount_to_word: ^2.0.0
```

Then run:

```bash
flutter pub get
```

## Number Formats

This package supports multiple number display formats:

| Format | Description | Persian Example | English Example | Turkish Example |
|--------|-------------|-----------------|-----------------|-----------------|
| **Words** | Pure text format | دو هزار و پانصد و شصت و شش | two thousand five hundred sixty-six | iki bin beş yüz altmış altı |
| **Mixed** | Digits + scale words | ۲ هزار و ۵۶۶ | 2 thousand 566 | 2 bin 566 |
| **Language Digits** | Native numerals | ۲,۵۶۶ | 2,566 | 2,566 |
| **Latin Digits** | Latin numerals | 2,566 | 2,566 | 2,566 |

## Quick Start

### Basic Number Conversion

```dart
import 'package:amount_to_word/amount_to_word.dart';

void main() {
  // Create converter for specific language
  final persianConverter = AmountToWords(Language.fa);
  final englishConverter = AmountToWords(Language.en);
  final turkishConverter = AmountToWords(Language.tr);
  
  // Convert numbers to words
  print(persianConverter.toWords(12345));  // دوازده هزار و سیصد و چهل و پنج
  print(englishConverter.toWords(12345));  // twelve thousand three hundred forty-five
  print(turkishConverter.toWords(12345));  // on iki bin üç yüz kırk beş
}
```

### Currency Conversion

```dart
import 'package:amount_to_word/amount_to_word.dart';

void main() {
  final converter = AmountToWords(Language.en);
  
  // US Dollar with proper pluralization
  print(converter.convert(1, currency: CurrencyConfig.usDollar));
  // Output: one dollar
  
  print(converter.convert(5.99, currency: CurrencyConfig.usDollar));
  // Output: five dollars and ninety-nine cents
  
  // Iranian currencies (no decimals)
  print(converter.convert(1000, currency: CurrencyConfig.iranianToman));
  // Output: one thousand toman
}
```

### Mixed Format (Digits + Words)

The mixed format combines digits with scale words for a more compact and readable representation:

```dart
import 'package:amount_to_word/amount_to_word.dart';

void main() {
  final faConverter = AmountToWords(Language.fa);
  final enConverter = AmountToWords(Language.en);
  final trConverter = AmountToWords(Language.tr);
  
  final number = 2566;
  
  // Persian mixed format
  print(faConverter.toMixed(number));
  // Output: ۲ هزار و ۵۶۶
  
  // English mixed format
  print(enConverter.toMixed(number));
  // Output: 2 thousand 566
  
  // Turkish mixed format
  print(trConverter.toMixed(number));
  // Output: 2 bin 566
  
  // With currency
  print(faConverter.convertToMixed(2566.75, currency: CurrencyConfig.usDollar));
  // Output: ۲ هزار و ۵۶۶ دلار و ۷۵ سنت
  
  print(enConverter.convertToMixed(2566.75, currency: CurrencyConfig.usDollar));
  // Output: 2 thousand 566 dollars and 75 cents
}
```

### Number Format Configuration

Customize the display format with `NumberFormatConfig`:

```dart
import 'package:amount_to_word/amount_to_word.dart';

void main() {
  final converter = AmountToWords(Language.fa);
  
  // Mixed format configuration
  final mixedConfig = NumberFormatConfig(
    format: NumberFormat.mixed,
    mixedFormatThreshold: 100, // Numbers below this use pure words
  );
  
  print(converter.toMixed(95));  // پنج و نود (below threshold)
  print(converter.toMixed(2566, formatConfig: mixedConfig));  // ۲ هزار و ۵۶۶
  
  // Language digits with commas
  final digitConfig = NumberFormatConfig(
    format: NumberFormat.languageDigits,
    addCommas: true,
  );
  
  print(NumberFormatter.formatLanguageNumber(1234567, Language.fa, addCommas: true));
  // Output: ۱,۲۳۴,۵۶۷
}
```

### Flutter Integration with Auto-Detection

```dart
import 'package:flutter/material.dart';
import 'package:amount_to_word/amount_to_word.dart';

class PriceDisplay extends StatelessWidget {
  final double amount;
  final CurrencyConfig currency;
  
  const PriceDisplay({required this.amount, required this.currency});
  
  @override
  Widget build(BuildContext context) {
    // Automatically detects language from app locale
    final converter = AmountToWords.fromContext(context);
    
    return Column(
      children: [
        Text('$amount'),
        Text(
          converter.convert(amount, currency: currency),
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
```

## Advanced Usage

### Custom Currency Configuration

```dart
// Create custom currency
final bitcoin = CurrencyConfig(
  mainUnits: {
    Language.en: 'bitcoin',
    Language.fa: 'بیت‌کوین',
    Language.tr: 'bitcoin',
  },
  subUnits: {
    Language.en: 'satoshi',
    Language.fa: 'ساتوشی',
    Language.tr: 'satoshi',
  },
  subUnitInMainUnit: 100000000, // 100M satoshis = 1 bitcoin
);

final converter = AmountToWords(Language.en);
print(converter.convert(1.5, currency: bitcoin));
// Output: one bitcoin and fifty million satoshis
```

### Adding New Languages to Existing Currencies

```dart
// Extend existing currency with new language support
final usdWithArabic = CurrencyConfig.usDollar.addLanguage(
  Language.en, // Using English as placeholder for new language
  'dollar (arabic)',
  'cent (arabic)',
);

// Use the extended currency
final result = converter.convert(100.50, currency: usdWithArabic);
```

### Integration with App's Currency System

```dart
// Map your app's currency enum to package currencies
enum AppCurrency { rial, toman, dollar, euro, lira }

CurrencyConfig getCurrencyConfig(AppCurrency appCurrency) {
  return CurrencyConfig.getByAppCurrency(appCurrency);
}

// Usage
final config = getCurrencyConfig(AppCurrency.dollar);
final result = converter.convert(amount, currency: config);
```

## API Reference

### AmountToWords Class

#### Constructors

- `AmountToWords(Language language)` - Create converter for specific language
- `AmountToWords.fromLocale([String? localeCode])` - Auto-detect from locale code
- `AmountToWords.fromContext(BuildContext context)` - Auto-detect from Flutter context

#### Methods

- `String toWords(num number)` - Convert number to words (no currency)
- `String convert(num amount, {CurrencyConfig? currency})` - Convert amount with currency
- `String integerToWords(int number)` - Convert integer only
- `bool isValidNumber(num number)` - Check if number is in supported range

#### Properties

- `Language language` - Current language
- `String conjunctionWord` - Conjunction word for current language ("و", "and", "ve")

### CurrencyConfig Class

#### Constructors

- `CurrencyConfig({required Map<Language, String> mainUnits, Map<Language, String>? subUnits, int subUnitInMainUnit = 100})`

#### Methods

- `String getMainUnit(Language language, {int count = 1})` - Get main unit with pluralization
- `String? getSubUnit(Language language, {int count = 1})` - Get sub unit with pluralization
- `CurrencyConfig addLanguage(Language language, String mainUnit, [String? subUnit])` - Add new language support

#### Properties

- `bool hasSubUnit` - Whether currency supports decimal amounts
- `int subUnitInMainUnit` - Conversion ratio (default: 100)

#### Predefined Currencies

- `CurrencyConfig.iranianRial`
- `CurrencyConfig.iranianToman`
- `CurrencyConfig.usDollar`
- `CurrencyConfig.euro`
- `CurrencyConfig.canadianDollar`
- `CurrencyConfig.turkishLira`
- `CurrencyConfig.afghanAfghani`

### Language Enum

```dart
enum Language {
  fa('fa', 'Persian'),
  en('en', 'English'),
  tr('tr', 'Turkish');
}
```

#### Methods

- `static Language? fromCode(String code)` - Get language from code
- `String get code` - Language code ('fa', 'en', 'tr')
- `String get name` - Language display name

## Pluralization Rules

### English
- Regular: `dollar` → `dollars`, `cent` → `cents`
- Y-ending: `penny` → `pennies`
- S/SH/CH/X/Z-ending: `lira` → `liras`

### Persian & Turkish
- No pluralization for currency units (grammatically correct)

## Number Range Support

- **Minimum**: 0
- **Maximum**: 999,999,999,999,999 (quadrillion range)
- **Decimal Places**: Up to 2 decimal places
- **Negative Numbers**: Not supported (throws `ArgumentError`)

## Error Handling

```dart
try {
  final result = converter.toWords(-100); // Throws ArgumentError
} catch (e) {
  print('Error: $e');
}

try {
  final result = converter.toWords(1e20); // Out of range
} catch (e) {
  print('Error: $e');
}
```

## Performance Considerations

- ✅ **Fast**: O(log n) complexity for number conversion
- ✅ **Memory Efficient**: Minimal memory footprint
- ✅ **No Network**: Pure offline implementation
- ✅ **Cached**: Language converters are reusable

## Testing

Run tests:

```bash
flutter test
```

The package includes comprehensive tests covering:
- All number ranges and edge cases
- Currency conversion accuracy
- Pluralization rules
- Language detection
- Error conditions
- Performance benchmarks

## Examples

Check the `/example` directory for complete working examples:

- `basic_usage.dart` - Simple number conversion
- `currency_usage.dart` - Currency examples with all supported currencies
- `flutter_integration.dart` - Complete Flutter app example
- `custom_currency.dart` - Advanced currency customization

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

### Adding New Languages

1. Add language to `Language` enum in `language_enum.dart`
2. Create new converter class extending `ConverterBase`
3. Add language support to all predefined currencies
4. Add comprehensive tests
5. Update documentation

### Adding New Currencies

1. Define currency in `CurrencyConfig` with all supported languages
2. Add to `getAllCurrencies()` method
3. Add tests in `currency_config_test.dart`
4. Update documentation

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and migration guides.

## Support

- 📧 **Issues**: [GitHub Issues](https://github.com/your-username/amount_to_word/issues)
- 📖 **Documentation**: [API Documentation](https://pub.dev/documentation/amount_to_word/latest/)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/your-username/amount_to_word/discussions)

---

Made with ❤️ for the Flutter community