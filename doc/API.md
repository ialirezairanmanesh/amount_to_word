# API Reference - Amount to Words Package

Complete API documentation for the Amount to Words package.

## Table of Contents

1. [AmountToWords Class](#amounttowords-class)
2. [CurrencyConfig Class](#currencyconfig-class)
3. [Language Enum](#language-enum)
4. [ConverterBase Class](#converterbase-class)
5. [Individual Converters](#individual-converters)
6. [Utility Methods](#utility-methods)
7. [Error Types](#error-types)

## AmountToWords Class

Main entry point for number-to-word conversion.

### Constructors

#### `AmountToWords(Language language)`

Creates a converter for a specific language.

```dart
final converter = AmountToWords(Language.fa); // Persian
final converter = AmountToWords(Language.en); // English
final converter = AmountToWords(Language.tr); // Turkish
```

**Parameters:**
- `language` (Language): Target language for conversion

#### `AmountToWords.fromLocale([String? localeCode])`

Creates a converter by auto-detecting language from locale code.

```dart
final converter = AmountToWords.fromLocale('fa'); // Persian
final converter = AmountToWords.fromLocale('en'); // English
final converter = AmountToWords.fromLocale();     // System default
```

**Parameters:**
- `localeCode` (String?, optional): Locale code (e.g., 'fa', 'en', 'tr')

**Returns:** AmountToWords instance with detected language, falls back to English if unsupported

#### `AmountToWords.fromContext(BuildContext context)`

Creates a converter by detecting language from Flutter app context.

```dart
Widget build(BuildContext context) {
  final converter = AmountToWords.fromContext(context);
  // Uses current app locale
}
```

**Parameters:**
- `context` (BuildContext): Flutter build context

**Returns:** AmountToWords instance with detected language

### Instance Methods

#### `String toWords(num number)`

Converts a number to words without currency information.

```dart
converter.toWords(123);    // "one hundred twenty-three"
converter.toWords(45.67);  // "forty-five and sixty-seven hundredths"
converter.toWords(0);      // "zero"
```

**Parameters:**
- `number` (num): Number to convert (int or double)

**Returns:** String representation of the number in words

**Throws:** ArgumentError if number is out of supported range or negative

#### `String convert(num amount, {CurrencyConfig? currency})`

Converts an amount to words with optional currency information.

```dart
// Without currency (same as toWords)
converter.convert(123.45);

// With currency
converter.convert(123.45, currency: CurrencyConfig.usDollar);
// "one hundred twenty-three dollars and forty-five cents"
```

**Parameters:**
- `amount` (num): Amount to convert
- `currency` (CurrencyConfig?, optional): Currency configuration

**Returns:** String representation of the amount with currency units

#### `String integerToWords(int number)`

Converts an integer to words (no decimal handling).

```dart
converter.integerToWords(123);   // "one hundred twenty-three"
converter.integerToWords(0);     // "zero"
```

**Parameters:**
- `number` (int): Integer to convert

**Returns:** String representation of the integer

**Throws:** ArgumentError if number is negative or out of range

#### `bool isValidNumber(num number)`

Checks if a number is within the supported range.

```dart
converter.isValidNumber(123);         // true
converter.isValidNumber(-1);          // false
converter.isValidNumber(1e20);        // false
```

**Parameters:**
- `number` (num): Number to validate

**Returns:** True if number is supported, false otherwise

### Properties

#### `Language language` (read-only)

Current language of the converter.

```dart
final converter = AmountToWords(Language.fa);
print(converter.language); // Language.fa
```

#### `String conjunctionWord` (read-only)

Conjunction word used by current language ("و", "and", "ve").

```dart
final faConverter = AmountToWords(Language.fa);
print(faConverter.conjunctionWord); // "و"

final enConverter = AmountToWords(Language.en);
print(enConverter.conjunctionWord); // "and"
```

### Static Methods

#### `static AmountToWords of(BuildContext context)`

Convenience method equivalent to `fromContext()`.

```dart
final converter = AmountToWords.of(context);
```

#### `static String convertWithContext(BuildContext context, num number, {CurrencyConfig? currency})`

One-shot conversion using context for language detection.

```dart
final result = AmountToWords.convertWithContext(
  context, 
  123.45, 
  currency: CurrencyConfig.usDollar,
);
```

#### `static Map<Language, AmountToWords> createAll()`

Creates converter instances for all supported languages.

```dart
final converters = AmountToWords.createAll();
final faConverter = converters[Language.fa]!;
final enConverter = converters[Language.en]!;
```

## CurrencyConfig Class

Configuration for currency units with multi-language support.

### Constructor

#### `CurrencyConfig({required Map<Language, String> mainUnits, Map<Language, String>? subUnits, int subUnitInMainUnit = 100})`

Creates a currency configuration.

```dart
final customCurrency = CurrencyConfig(
  mainUnits: {
    Language.en: 'token',
    Language.fa: 'ژتون',
    Language.tr: 'jeton',
  },
  subUnits: {
    Language.en: 'bit',
    Language.fa: 'بیت',
    Language.tr: 'bit',
  },
  subUnitInMainUnit: 1000,
);
```

**Parameters:**
- `mainUnits` (Map<Language, String>): Main currency unit names for each language
- `subUnits` (Map<Language, String>?, optional): Sub-currency unit names for each language
- `subUnitInMainUnit` (int, default: 100): Number of sub-units in one main unit

### Instance Methods

#### `String getMainUnit(Language language, {int count = 1})`

Gets the main currency unit for a specific language with pluralization.

```dart
final currency = CurrencyConfig.usDollar;

currency.getMainUnit(Language.en);           // "dollar"
currency.getMainUnit(Language.en, count: 1); // "dollar"
currency.getMainUnit(Language.en, count: 5); // "dollars"
currency.getMainUnit(Language.fa, count: 5); // "دلار" (no pluralization)
```

**Parameters:**
- `language` (Language): Target language
- `count` (int, default: 1): Count for pluralization rules

**Returns:** Currency unit name, pluralized if applicable

#### `String? getSubUnit(Language language, {int count = 1})`

Gets the sub-currency unit for a specific language with pluralization.

```dart
final currency = CurrencyConfig.usDollar;

currency.getSubUnit(Language.en);           // "cent"
currency.getSubUnit(Language.en, count: 1); // "cent"
currency.getSubUnit(Language.en, count: 99); // "cents"

// For currencies without sub-units
CurrencyConfig.iranianRial.getSubUnit(Language.en); // null
```

**Parameters:**
- `language` (Language): Target language
- `count` (int, default: 1): Count for pluralization rules

**Returns:** Sub-currency unit name, or null if currency doesn't support decimals

#### `String getMainUnitByCode(String languageCode, {int count = 1})`

Gets main unit by language code string.

```dart
currency.getMainUnitByCode('en');           // "dollar"
currency.getMainUnitByCode('en', count: 5); // "dollars"
currency.getMainUnitByCode('unknown');      // "dollar" (fallback to English)
```

#### `String? getSubUnitByCode(String languageCode, {int count = 1})`

Gets sub-unit by language code string.

```dart
currency.getSubUnitByCode('en');           // "cent"
currency.getSubUnitByCode('en', count: 99); // "cents"
```

#### `CurrencyConfig addLanguage(Language language, String mainUnit, [String? subUnit])`

Creates a new currency configuration with additional language support.

```dart
final usdExtended = CurrencyConfig.usDollar.addLanguage(
  Language.tr, // Adding Turkish
  'amerikan doları',
  'amerikan senti',
);
```

**Parameters:**
- `language` (Language): Language to add
- `mainUnit` (String): Main unit name in the new language
- `subUnit` (String?, optional): Sub-unit name in the new language

**Returns:** New CurrencyConfig instance with added language

### Properties

#### `Map<Language, String> mainUnits` (read-only)

Map of main currency units for each language.

#### `Map<Language, String>? subUnits` (read-only)

Map of sub-currency units for each language, or null if currency doesn't support decimals.

#### `int subUnitInMainUnit` (read-only)

Number of sub-units in one main unit (typically 100).

#### `bool hasSubUnit` (read-only)

Whether this currency supports decimal amounts.

```dart
CurrencyConfig.usDollar.hasSubUnit;        // true
CurrencyConfig.iranianRial.hasSubUnit;     // false
```

### Predefined Currency Configurations

#### `static const CurrencyConfig iranianRial`

Iranian Rial configuration (no decimals).

```dart
final converter = AmountToWords(Language.fa);
converter.convert(1000, currency: CurrencyConfig.iranianRial);
// "یک هزار ریال"
```

#### `static const CurrencyConfig iranianToman`

Iranian Toman configuration (no decimals).

#### `static const CurrencyConfig usDollar`

US Dollar configuration with cents.

#### `static const CurrencyConfig euro`

Euro configuration with cents.

#### `static const CurrencyConfig canadianDollar`

Canadian Dollar configuration with cents.

#### `static const CurrencyConfig turkishLira`

Turkish Lira configuration with kuruş.

#### `static const CurrencyConfig afghanAfghani`

Afghan Afghani configuration (no decimals).

### Static Methods

#### `static List<CurrencyConfig> getAllCurrencies()`

Gets all predefined currency configurations.

```dart
final currencies = CurrencyConfig.getAllCurrencies();
for (final currency in currencies) {
  print(currency.getMainUnit(Language.en));
}
```

#### `static CurrencyConfig getByAppCurrency(dynamic appCurrency)`

Gets currency configuration by app's currency enum.

```dart
enum AppCurrency { rial, toman, dollar, euro }

final config = CurrencyConfig.getByAppCurrency(AppCurrency.dollar);
// Returns CurrencyConfig.usDollar
```

#### `static CurrencyConfig? getByCountry(String countryName)`

Gets currency configuration by country name.

```dart
final iranCurrency = CurrencyConfig.getByCountry('ایران');  // iranianToman
final usCurrency = CurrencyConfig.getByCountry('america');   // usDollar
```

### Deprecated Members

#### `@Deprecated String get mainUnit`

Use `getMainUnit(Language.fa)` instead.

#### `@Deprecated String? get subUnit`

Use `getSubUnit(Language.fa)` instead.

#### `@Deprecated static const CurrencyConfig tomanRial`

Use `iranianToman` instead.

#### `@Deprecated static const CurrencyConfig dollarCent`

Use `usDollar` instead.

#### `@Deprecated static const CurrencyConfig euroCent`

Use `euro` instead.

## Language Enum

Enumeration of supported languages.

### Values

#### `Language.fa`

Persian/Farsi language.

```dart
Language.fa.code;  // "fa"
Language.fa.name;  // "Persian"
```

#### `Language.en`

English language.

```dart
Language.en.code;  // "en"
Language.en.name;  // "English"
```

#### `Language.tr`

Turkish language.

```dart
Language.tr.code;  // "tr"
Language.tr.name;  // "Turkish"
```

### Properties

#### `String code` (read-only)

Language code (ISO 639-1).

#### `String name` (read-only)

Human-readable language name.

### Static Methods

#### `static Language? fromCode(String code)`

Gets language from code string.

```dart
Language.fromCode('fa');      // Language.fa
Language.fromCode('en');      // Language.en
Language.fromCode('tr');      // Language.tr
Language.fromCode('invalid'); // null
```

## ConverterBase Class

Abstract base class for language-specific converters.

### Abstract Properties

#### `Language get language`

Language supported by this converter.

#### `String get conjunctionWord`

Conjunction word for this language.

### Abstract Methods

#### `String numberToWords(num number)`

Converts number to words.

#### `String amountToWords(num amount, {CurrencyConfig? currency})`

Converts amount to words with currency.

#### `String integerToWords(int number)`

Converts integer to words.

#### `String decimalToWords(String decimalPart)`

Converts decimal part to words.

### Concrete Methods

#### `bool isValidNumber(num number)`

Validates if number is in supported range.

#### `Map<String, dynamic> splitNumber(num number)`

Splits number into integer and decimal parts.

```dart
converter.splitNumber(123.45);
// Returns: {'integer': 123, 'decimal': '45'}

converter.splitNumber(100.00);
// Returns: {'integer': 100, 'decimal': null}
```

## Individual Converters

### FaConverter

Persian/Farsi number converter.

```dart
final converter = FaConverter();
converter.language;            // Language.fa
converter.conjunctionWord;     // "و"
```

### EnConverter

English number converter.

```dart
final converter = EnConverter();
converter.language;            // Language.en
converter.conjunctionWord;     // "and"
```

### TrConverter

Turkish number converter.

```dart
final converter = TrConverter();
converter.language;            // Language.tr
converter.conjunctionWord;     // "ve"
```

## Utility Methods

### Number Range Constants

```dart
// Maximum supported number
static const int maxSupportedNumber = 999999999999999; // Quadrillion range

// Minimum supported number
static const int minSupportedNumber = 0;

// Maximum decimal places
static const int maxDecimalPlaces = 2;
```

### Validation Helpers

```dart
bool isValidInteger(int number) {
  return number >= 0 && number <= maxSupportedNumber;
}

bool isValidDecimal(double number) {
  return number >= 0.0 && number <= maxSupportedNumber.toDouble();
}
```

## Error Types

### ArgumentError

Thrown when invalid arguments are passed.

```dart
try {
  converter.toWords(-1); // Negative number
} catch (ArgumentError e) {
  print('Error: ${e.message}');
}

try {
  converter.toWords(1e20); // Out of range
} catch (ArgumentError e) {
  print('Error: ${e.message}');
}
```

**Common Causes:**
- Negative numbers
- Numbers exceeding maximum range
- Invalid number formats

### Usage Examples

#### Basic Error Handling

```dart
String safeConvert(AmountToWords converter, num number) {
  try {
    if (!converter.isValidNumber(number)) {
      return 'Number out of range';
    }
    return converter.toWords(number);
  } catch (ArgumentError e) {
    return 'Error: ${e.message}';
  } catch (e) {
    return 'Unexpected error: $e';
  }
}
```

#### Async Error Handling

```dart
Future<String> asyncConvert(AmountToWords converter, num number) async {
  try {
    // Use compute for very large numbers
    return await compute((num n) {
      return converter.toWords(n);
    }, number);
  } catch (e) {
    return 'Conversion failed: $e';
  }
}
```

## Performance Considerations

### Time Complexity

- Number conversion: O(log n) where n is the number value
- Currency conversion: O(log n) + O(1) for currency lookup
- Language detection: O(1)

### Memory Usage

- Each converter instance: ~50KB
- Currency configurations: ~10KB each
- No memory leaks in normal usage

### Optimization Tips

1. **Reuse Converters**: Create once, use multiple times
2. **Cache Frequently Used**: Cache converters for commonly used languages
3. **Validate Early**: Use `isValidNumber()` before conversion
4. **Async for Large Numbers**: Use `compute()` for numbers > 1 billion

---

This API reference covers all public interfaces of the Amount to Words package. For usage examples and best practices, see the [Complete Usage Guide](GUIDE.md).
