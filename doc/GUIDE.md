# Complete Usage Guide - Amount to Words Package

This comprehensive guide covers everything you need to know about using the Amount to Words package effectively in your Flutter applications.

## Table of Contents

1. [Installation & Setup](#installation--setup)
2. [Basic Concepts](#basic-concepts)
3. [Number Formats](#number-formats)
4. [Language Support](#language-support)
5. [Currency Configuration](#currency-configuration)
6. [Integration Patterns](#integration-patterns)
7. [Advanced Usage](#advanced-usage)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)
10. [Migration Guide](#migration-guide)

## Installation & Setup

### 1. Add Dependency

```yaml
dependencies:
  amount_to_word: ^2.0.0
```

### 2. Import Package

```dart
import 'package:amount_to_word/amount_to_word.dart';
```

### 3. Basic Initialization

```dart
// Method 1: Explicit language
final converter = AmountToWords(Language.en);

// Method 2: Auto-detect from locale
final converter = AmountToWords.fromLocale('en');

// Method 3: Auto-detect from Flutter context (recommended)
final converter = AmountToWords.fromContext(context);
```

## Basic Concepts

### Number to Words Conversion

The package converts numeric values to their word representation:

```dart
final converter = AmountToWords(Language.en);

// Integers
converter.toWords(0);      // "zero"
converter.toWords(42);     // "forty-two"
converter.toWords(1000);   // "one thousand"

// Decimals
converter.toWords(3.14);   // "three and fourteen hundredths"
converter.toWords(10.5);   // "ten and five tenths"

// Large numbers
converter.toWords(1000000); // "one million"
```

### Currency Integration

Convert amounts with proper currency units:

```dart
final converter = AmountToWords(Language.en);

// Basic currency conversion
converter.convert(123.45, currency: CurrencyConfig.usDollar);
// Output: "one hundred twenty-three dollars and forty-five cents"

// No currency (same as toWords)
converter.convert(123.45);
// Output: "one hundred twenty-three and forty-five hundredths"
```

## Number Formats

The package supports multiple number display formats to meet different use cases and presentation requirements.

### Available Formats

| Format | Description | Use Case | Persian Example | English Example |
|--------|-------------|----------|-----------------|-----------------|
| **Words** | Complete text representation | Legal documents, checks | دو هزار و پانصد و شصت و شش | two thousand five hundred sixty-six |
| **Mixed** | Digits + scale words | Invoices, compact display | ۲ هزار و ۵۶۶ | 2 thousand 566 |
| **Language Digits** | Native numeral system | Localized interfaces | ۲,۵۶۶ | 2,566 |
| **Latin Digits** | Universal digits | International usage | 2,566 | 2,566 |

### Basic Format Usage

```dart
final converter = AmountToWords(Language.fa);
final number = 2566;

// Pure words format (default)
print(converter.toWords(number));
// Output: دو هزار و پانصد و شصت و شش

// Mixed format (digits + scale words)
print(converter.toMixed(number));
// Output: ۲ هزار و ۵۶۶

// Format numbers directly
print(NumberFormatter.formatLanguageNumber(number, Language.fa));
// Output: ۲۵۶۶ (Persian digits)

print(NumberFormatter.formatLanguageNumber(number, Language.fa, addCommas: true));
// Output: ۲,۵۶۶ (with commas)
```

### Mixed Format Details

The mixed format combines the readability of words with the compactness of digits:

```dart
final faConverter = AmountToWords(Language.fa);
final enConverter = AmountToWords(Language.en);
final trConverter = AmountToWords(Language.tr);

final amount = 1234567;

// Persian: digits use Persian numerals, conjunctions maintained
print(faConverter.toMixed(amount));
// Output: ۱ میلیون و ۲۳۴ هزار و ۵۶۷

// English: Latin digits, no conjunction between major groups
print(enConverter.toMixed(amount));
// Output: 1 million 234 thousand 567

// Turkish: Latin digits, no conjunction between major groups
print(trConverter.toMixed(amount));
// Output: 1 milyon 234 bin 567
```

### Currency with Mixed Format

```dart
final converter = AmountToWords(Language.fa);

// Mixed format with currency
print(converter.convertToMixed(2566.75, currency: CurrencyConfig.usDollar));
// Output: ۲ هزار و ۵۶۶ دلار و ۷۵ سنت

// Compare with words format
print(converter.convert(2566.75, currency: CurrencyConfig.usDollar));
// Output: دو هزار و پانصد و شصت و شش دلار و هفتاد و پنج سنت
```

### Format Configuration

Customize formatting behavior with `NumberFormatConfig`:

```dart
// Custom threshold for mixed format
final customConfig = NumberFormatConfig(
  format: NumberFormat.mixed,
  mixedFormatThreshold: 50, // Numbers below 50 use pure words
);

final converter = AmountToWords(Language.en);

// Below threshold: uses words
print(converter.toMixed(25, formatConfig: customConfig));
// Output: twenty-five

// Above threshold: uses mixed format
print(converter.toMixed(1500, formatConfig: customConfig));
// Output: 1 thousand 500

// Language digits with commas
final digitConfig = NumberFormatConfig(
  format: NumberFormat.languageDigits,
  addCommas: true,
);

print(NumberFormatter.formatLanguageNumber(1234567, Language.fa, addCommas: true));
// Output: ۱,۲۳۴,۵۶۷
```

### Language-Specific Digit Conversion

```dart
// Convert between numeral systems
final latinNumber = "12345";

// To Persian digits
print(NumberFormatter.toPersianDigits(latinNumber)); // ۱۲۳۴۵

// To Arabic digits
print(NumberFormatter.toArabicDigits(latinNumber)); // ١٢٣٤٥

// Back to Latin
final persianNumber = "۱۲۳۴۵";
print(NumberFormatter.toLatinDigits(persianNumber)); // 12345

// Detect digit types
print(NumberFormatter.containsPersianDigits("۱۲۳")); // true
print(NumberFormatter.containsArabicDigits("١٢٣")); // true
```

### Format Best Practices

1. **Choose the right format for your use case:**
   - Use **Words** for legal documents and formal contracts
   - Use **Mixed** for invoices and financial displays
   - Use **Language Digits** for localized user interfaces
   - Use **Latin Digits** for international applications

2. **Consider your audience:**
   - Persian speakers prefer Persian digits in Persian text
   - International users may prefer Latin digits
   - Mixed format provides good readability for large numbers

3. **Performance considerations:**
   - Mixed format is faster than full words conversion
   - Digit formats are fastest for display-only scenarios

## Language Support

### Supported Languages

| Language | Code | Enum | Native Name |
|----------|------|------|-------------|
| Persian/Farsi | `fa` | `Language.fa` | فارسی |
| English | `en` | `Language.en` | English |
| Turkish | `tr` | `Language.tr` | Türkçe |

### Language-Specific Examples

#### Persian (فارسی)

```dart
final fa = AmountToWords(Language.fa);

fa.toWords(1234);     // "یک هزار و دویست و سی و چهار"
fa.toWords(0);        // "صفر"
fa.toWords(10.25);    // "ده و بیست و پنج صدم"

// With currency
fa.convert(1000, currency: CurrencyConfig.iranianToman);
// Output: "یک هزار تومان"
```

#### English

```dart
final en = AmountToWords(Language.en);

en.toWords(1234);     // "one thousand two hundred thirty-four"
en.toWords(0);        // "zero"
en.toWords(10.25);    // "ten and twenty-five hundredths"

// With currency
en.convert(1000, currency: CurrencyConfig.usDollar);
// Output: "one thousand dollars"
```

#### Turkish (Türkçe)

```dart
final tr = AmountToWords(Language.tr);

tr.toWords(1234);     // "bin iki yüz otuz dört"
tr.toWords(0);        // "sıfır"
tr.toWords(10.25);    // "on ve yirmi beş yüzde"

// With currency
tr.convert(1000, currency: CurrencyConfig.turkishLira);
// Output: "bin lira"
```

### Language Detection

#### Automatic Detection

```dart
// From Flutter context (recommended)
Widget build(BuildContext context) {
  final converter = AmountToWords.fromContext(context);
  // Automatically uses app's current locale
}

// From locale string
final converter = AmountToWords.fromLocale('fa');  // Persian
final converter = AmountToWords.fromLocale('en');  // English
final converter = AmountToWords.fromLocale('tr');  // Turkish
final converter = AmountToWords.fromLocale('fr');  // Falls back to English
```

#### Manual Language Selection

```dart
// Create converters for all languages
final converters = {
  Language.fa: AmountToWords(Language.fa),
  Language.en: AmountToWords(Language.en),
  Language.tr: AmountToWords(Language.tr),
};

// Use based on user preference
final userLanguage = getUserPreferredLanguage();
final converter = converters[userLanguage] ?? converters[Language.en]!;
```

## Currency Configuration

### Predefined Currencies

The package includes currencies commonly used in Iranian, international, and regional applications:

#### Iranian Currencies (No Decimals)

```dart
// Iranian Rial
CurrencyConfig.iranianRial
// Persian: ریال, English: rial, Turkish: rial

// Iranian Toman  
CurrencyConfig.iranianToman
// Persian: تومان, English: toman, Turkish: toman
```

#### International Currencies (With Decimals)

```dart
// US Dollar
CurrencyConfig.usDollar
// Persian: دلار/سنت, English: dollar/cent, Turkish: dolar/sent

// Euro
CurrencyConfig.euro
// Persian: یورو/سنت, English: euro/cent, Turkish: euro/sent

// Canadian Dollar
CurrencyConfig.canadianDollar
// Persian: دلار کانادا/سنت, English: canadian dollar/cent, Turkish: kanada doları/sent
```

#### Regional Currencies

```dart
// Turkish Lira
CurrencyConfig.turkishLira
// Persian: لیر/قروش, English: lira/kurus, Turkish: lira/kuruş

// Afghan Afghani (No Decimals)
CurrencyConfig.afghanAfghani
// Persian: افغانی, English: afghani, Turkish: afgani
```

### Currency Properties

#### Checking Decimal Support

```dart
final currency = CurrencyConfig.usDollar;

if (currency.hasSubUnit) {
  print("Currency supports decimals");
  print("Ratio: ${currency.subUnitInMainUnit}"); // 100
} else {
  print("Currency doesn't support decimals");
}
```

#### Getting Currency Units

```dart
final currency = CurrencyConfig.usDollar;

// Get main unit
currency.getMainUnit(Language.en);           // "dollar"
currency.getMainUnit(Language.en, count: 1); // "dollar" (singular)
currency.getMainUnit(Language.en, count: 5); // "dollars" (plural)

// Get sub unit
currency.getSubUnit(Language.en);           // "cent"
currency.getSubUnit(Language.en, count: 1); // "cent" (singular)
currency.getSubUnit(Language.en, count: 99); // "cents" (plural)
```

### Custom Currency Creation

#### Basic Custom Currency

```dart
final customCurrency = CurrencyConfig(
  mainUnits: {
    Language.en: 'point',
    Language.fa: 'امتیاز',
    Language.tr: 'puan',
  },
  subUnits: {
    Language.en: 'subpoint',
    Language.fa: 'زیرامتیاز',
    Language.tr: 'alt puan',
  },
  subUnitInMainUnit: 100,
);

final converter = AmountToWords(Language.en);
print(converter.convert(5.25, currency: customCurrency));
// Output: "five points and twenty-five subpoints"
```

#### Currency Without Decimals

```dart
final tokenCurrency = CurrencyConfig(
  mainUnits: {
    Language.en: 'token',
    Language.fa: 'ژتون',
  },
  // No subUnits - doesn't support decimals
);

final converter = AmountToWords(Language.en);
print(converter.convert(42.99, currency: tokenCurrency));
// Output: "forty-two tokens" (decimals ignored)
```

#### Extending Existing Currencies

```dart
// Add new language to existing currency
final usdExtended = CurrencyConfig.usDollar.addLanguage(
  Language.en, // Using existing language as example
  'american dollar',
  'american cent',
);

// Use the extended currency
final result = converter.convert(100, currency: usdExtended);
```

### Pluralization Rules

#### English Pluralization

The package automatically handles English pluralization:

```dart
final converter = AmountToWords(Language.en);

// Regular pluralization (add 's')
converter.convert(1, currency: CurrencyConfig.usDollar);     // "one dollar"
converter.convert(2, currency: CurrencyConfig.usDollar);     // "two dollars"

// Y-ending words (y -> ies)
final customPenny = CurrencyConfig(
  mainUnits: {Language.en: 'pound'},
  subUnits: {Language.en: 'penny'},
);
converter.convert(1.02, currency: customPenny);              // "one pound and two pennies"

// S/SH/CH/X/Z-ending words (add 'es')
final customLira = CurrencyConfig(
  mainUnits: {Language.en: 'lira'},
);
converter.convert(5, currency: customLira);                  // "five liras"
```

#### Persian & Turkish

Persian and Turkish don't pluralize currency units:

```dart
// Persian - same form regardless of count
final fa = AmountToWords(Language.fa);
fa.convert(1, currency: CurrencyConfig.iranianToman);   // "یک تومان"
fa.convert(100, currency: CurrencyConfig.iranianToman); // "صد تومان"

// Turkish - same form regardless of count
final tr = AmountToWords(Language.tr);
tr.convert(1, currency: CurrencyConfig.turkishLira);    // "bir lira"
tr.convert(100, currency: CurrencyConfig.turkishLira);  // "yüz lira"
```

## Integration Patterns

### Flutter Widget Integration

#### Basic Widget

```dart
class AmountDisplay extends StatelessWidget {
  final double amount;
  final CurrencyConfig? currency;
  
  const AmountDisplay({
    super.key,
    required this.amount,
    this.currency,
  });
  
  @override
  Widget build(BuildContext context) {
    final converter = AmountToWords.fromContext(context);
    final wordsText = currency != null
        ? converter.convert(amount, currency: currency)
        : converter.toWords(amount);
    
    return Column(
      children: [
        Text(
          amount.toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          wordsText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
```

#### Localizable Widget

```dart
class LocalizableAmountDisplay extends StatelessWidget {
  final double amount;
  final CurrencyConfig currency;
  
  const LocalizableAmountDisplay({
    super.key,
    required this.amount,
    required this.currency,
  });
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final converter = AmountToWords.fromContext(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: $amount',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'In words (${locale.languageCode}):',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              converter.convert(amount, currency: currency),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### App State Integration

#### With Provider/Riverpod

```dart
// Provider
class AmountProvider extends ChangeNotifier {
  double _amount = 0.0;
  CurrencyConfig _currency = CurrencyConfig.usDollar;
  
  double get amount => _amount;
  CurrencyConfig get currency => _currency;
  
  void updateAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }
  
  void updateCurrency(CurrencyConfig newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }
  
  String getAmountInWords(BuildContext context) {
    final converter = AmountToWords.fromContext(context);
    return converter.convert(_amount, currency: _currency);
  }
}

// Widget usage
class AmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AmountProvider>(
      builder: (context, provider, child) {
        return Text(provider.getAmountInWords(context));
      },
    );
  }
}
```

#### With BLoC

```dart
// Event
abstract class AmountEvent {}

class AmountChanged extends AmountEvent {
  final double amount;
  final CurrencyConfig currency;
  AmountChanged(this.amount, this.currency);
}

// State
class AmountState {
  final double amount;
  final CurrencyConfig currency;
  final String amountInWords;
  
  AmountState({
    required this.amount,
    required this.currency,
    required this.amountInWords,
  });
}

// BLoC
class AmountBloc extends Bloc<AmountEvent, AmountState> {
  AmountBloc() : super(AmountState(
    amount: 0.0,
    currency: CurrencyConfig.usDollar,
    amountInWords: '',
  )) {
    on<AmountChanged>(_onAmountChanged);
  }
  
  void _onAmountChanged(AmountChanged event, Emitter<AmountState> emit) {
    final converter = AmountToWords(Language.en); // Or get from context
    final wordsText = converter.convert(event.amount, currency: event.currency);
    
    emit(AmountState(
      amount: event.amount,
      currency: event.currency,
      amountInWords: wordsText,
    ));
  }
}
```

### Form Integration

#### Input Form with Real-time Conversion

```dart
class AmountInputForm extends StatefulWidget {
  @override
  _AmountInputFormState createState() => _AmountInputFormState();
}

class _AmountInputFormState extends State<AmountInputForm> {
  final _controller = TextEditingController();
  double _amount = 0.0;
  CurrencyConfig _selectedCurrency = CurrencyConfig.usDollar;
  
  @override
  Widget build(BuildContext context) {
    final converter = AmountToWords.fromContext(context);
    
    return Column(
      children: [
        // Amount input
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Enter Amount',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _amount = double.tryParse(value) ?? 0.0;
            });
          },
        ),
        
        SizedBox(height: 16),
        
        // Currency selection
        DropdownButtonFormField<CurrencyConfig>(
          value: _selectedCurrency,
          decoration: InputDecoration(
            labelText: 'Currency',
            border: OutlineInputBorder(),
          ),
          items: CurrencyConfig.getAllCurrencies().map((currency) {
            final name = currency.getMainUnit(Language.en);
            return DropdownMenuItem(
              value: currency,
              child: Text(name.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCurrency = value!;
            });
          },
        ),
        
        SizedBox(height: 16),
        
        // Live conversion result
        if (_amount > 0) ...[
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount in Words:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    converter.convert(_amount, currency: _selectedCurrency),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## Advanced Usage

### Multi-Language Support in Single App

```dart
class MultiLanguageAmountDisplay extends StatelessWidget {
  final double amount;
  final CurrencyConfig currency;
  
  const MultiLanguageAmountDisplay({
    super.key,
    required this.amount,
    required this.currency,
  });
  
  @override
  Widget build(BuildContext context) {
    final languages = [Language.fa, Language.en, Language.tr];
    
    return Column(
      children: languages.map((language) {
        final converter = AmountToWords(language);
        final result = converter.convert(amount, currency: currency);
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  language.name + ':',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Text(result)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
```

### Performance Optimization

#### Converter Caching

```dart
class AmountConverterService {
  static final Map<Language, AmountToWords> _converters = {};
  
  static AmountToWords getConverter(Language language) {
    return _converters.putIfAbsent(
      language,
      () => AmountToWords(language),
    );
  }
  
  static String convertAmount(
    double amount, {
    required Language language,
    CurrencyConfig? currency,
  }) {
    final converter = getConverter(language);
    return currency != null
        ? converter.convert(amount, currency: currency)
        : converter.toWords(amount);
  }
}
```

#### Async Processing for Large Numbers

```dart
class AsyncAmountConverter {
  static Future<String> convertLargeAmount(
    double amount, {
    required Language language,
    CurrencyConfig? currency,
  }) async {
    // Use compute for CPU-intensive operations
    return await compute(_convertAmount, {
      'amount': amount,
      'language': language,
      'currency': currency,
    });
  }
  
  static String _convertAmount(Map<String, dynamic> params) {
    final amount = params['amount'] as double;
    final language = params['language'] as Language;
    final currency = params['currency'] as CurrencyConfig?;
    
    final converter = AmountToWords(language);
    return currency != null
        ? converter.convert(amount, currency: currency)
        : converter.toWords(amount);
  }
}
```

### Custom Number Formatters

#### Creating Specialized Formatters

```dart
class InvoiceAmountFormatter {
  final Language language;
  final CurrencyConfig currency;
  late final AmountToWords _converter;
  
  InvoiceAmountFormatter({
    required this.language,
    required this.currency,
  }) {
    _converter = AmountToWords(language);
  }
  
  String formatInvoiceAmount(double amount) {
    final wordsAmount = _converter.convert(amount, currency: currency);
    
    // Add formatting specific to invoices
    switch (language) {
      case Language.fa:
        return 'مبلغ: $wordsAmount';
      case Language.en:
        return 'Amount: $wordsAmount';
      case Language.tr:
        return 'Tutar: $wordsAmount';
    }
  }
  
  String formatWithTax(double baseAmount, double taxRate) {
    final taxAmount = baseAmount * taxRate;
    final totalAmount = baseAmount + taxAmount;
    
    final baseWords = _converter.convert(baseAmount, currency: currency);
    final taxWords = _converter.convert(taxAmount, currency: currency);
    final totalWords = _converter.convert(totalAmount, currency: currency);
    
    switch (language) {
      case Language.fa:
        return '''
مبلغ پایه: $baseWords
مالیات: $taxWords
مجموع: $totalWords
''';
      case Language.en:
        return '''
Base Amount: $baseWords
Tax: $taxWords
Total: $totalWords
''';
      case Language.tr:
        return '''
Ana Tutar: $baseWords
Vergi: $taxWords
Toplam: $totalWords
''';
    }
  }
}
```

## Best Practices

### 1. Context-Based Language Detection

Always prefer context-based language detection for Flutter apps:

```dart
// ✅ Good - Automatic language detection
final converter = AmountToWords.fromContext(context);

// ❌ Avoid - Hard-coded language
final converter = AmountToWords(Language.en);
```

### 2. Currency Selection Strategy

#### For International Apps

```dart
class CurrencyHelper {
  static CurrencyConfig getCurrencyForRegion(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'IR':
        return CurrencyConfig.iranianToman;
      case 'US':
        return CurrencyConfig.usDollar;
      case 'EU':
      case 'DE':
      case 'FR':
        return CurrencyConfig.euro;
      case 'TR':
        return CurrencyConfig.turkishLira;
      case 'AF':
        return CurrencyConfig.afghanAfghani;
      case 'CA':
        return CurrencyConfig.canadianDollar;
      default:
        return CurrencyConfig.usDollar; // Fallback
    }
  }
}
```

#### For Regional Apps

```dart
// For Iranian market apps
class IranianCurrencyHelper {
  static CurrencyConfig getPreferredCurrency() {
    // Most Iranian apps prefer Toman over Rial
    return CurrencyConfig.iranianToman;
  }
  
  static String formatIranianAmount(double amount) {
    final converter = AmountToWords(Language.fa);
    return converter.convert(amount, currency: CurrencyConfig.iranianToman);
  }
}
```

### 3. Error Handling

```dart
class SafeAmountConverter {
  static String safeConvert(
    double amount, {
    required BuildContext context,
    CurrencyConfig? currency,
  }) {
    try {
      final converter = AmountToWords.fromContext(context);
      return currency != null
          ? converter.convert(amount, currency: currency)
          : converter.toWords(amount);
    } catch (e) {
      // Log error and return fallback
      debugPrint('Amount conversion error: $e');
      return amount.toString(); // Fallback to numeric display
    }
  }
}
```

### 4. Testing Integration

```dart
// Test helper for consistent testing
class TestAmountHelper {
  static const testCases = [
    (0, 'zero'),
    (1, 'one'),
    (42, 'forty-two'),
    (1000, 'one thousand'),
    (1234567, 'one million two hundred thirty-four thousand five hundred sixty-seven'),
  ];
  
  static void testConverter(AmountToWords converter) {
    for (final (number, expected) in testCases) {
      final result = converter.toWords(number);
      assert(result == expected, 'Failed for $number: got "$result", expected "$expected"');
    }
  }
}
```

### 5. Performance Optimization

```dart
// Singleton pattern for frequently used converters
class ConverterManager {
  static final Map<Language, AmountToWords> _cache = {};
  
  static AmountToWords getConverter(Language language) {
    return _cache.putIfAbsent(language, () => AmountToWords(language));
  }
  
  static void preloadConverters() {
    for (final language in Language.values) {
      getConverter(language);
    }
  }
}
```

## Troubleshooting

### Common Issues

#### 1. Wrong Language Detection

**Problem**: App shows wrong language despite correct locale

```dart
// ❌ Problem - Language not updating
final converter = AmountToWords.fromLocale('en'); // Static
```

**Solution**: Use context-based detection

```dart
// ✅ Solution - Dynamic language detection
final converter = AmountToWords.fromContext(context);
```

#### 2. Decimal Precision Issues

**Problem**: Decimals showing incorrectly

```dart
// ❌ Problem - Too many decimal places
final result = converter.toWords(1.999999); // Might show unexpected result
```

**Solution**: Round amounts before conversion

```dart
// ✅ Solution - Control decimal precision
final roundedAmount = (amount * 100).round() / 100; // 2 decimal places
final result = converter.toWords(roundedAmount);
```

#### 3. Currency Not Pluralizing

**Problem**: English currency not showing plurals

```dart
// ❌ Problem - Not using count parameter
final mainUnit = currency.getMainUnit(Language.en); // Always singular
```

**Solution**: Pass count to get proper pluralization

```dart
// ✅ Solution - Use count parameter
final amount = 5;
final mainUnit = currency.getMainUnit(Language.en, count: amount); // "dollars"
```

#### 4. Memory Issues with Large Numbers

**Problem**: App freezing on very large numbers

```dart
// ❌ Problem - Processing huge numbers on main thread
final result = converter.toWords(999999999999999);
```

**Solution**: Use async processing for large numbers

```dart
// ✅ Solution - Async processing
final result = await compute((amount) {
  final converter = AmountToWords(Language.en);
  return converter.toWords(amount);
}, 999999999999999);
```

### Debugging Tips

#### 1. Enable Debug Logging

```dart
class DebugAmountConverter {
  static String convertWithLogging(
    double amount, {
    required Language language,
    CurrencyConfig? currency,
  }) {
    debugPrint('Converting: $amount with $language');
    
    final converter = AmountToWords(language);
    final result = currency != null
        ? converter.convert(amount, currency: currency)
        : converter.toWords(amount);
    
    debugPrint('Result: $result');
    return result;
  }
}
```

#### 2. Validate Input Ranges

```dart
class ValidatedAmountConverter {
  static String? validateAndConvert(
    double amount, {
    required AmountToWords converter,
    CurrencyConfig? currency,
  }) {
    // Check range
    if (!converter.isValidNumber(amount)) {
      return 'Number out of supported range';
    }
    
    // Check for negative
    if (amount < 0) {
      return 'Negative numbers not supported';
    }
    
    // Convert
    try {
      return currency != null
          ? converter.convert(amount, currency: currency)
          : converter.toWords(amount);
    } catch (e) {
      return 'Conversion failed: $e';
    }
  }
}
```

## Migration Guide

### From Version 1.x to 2.x

#### Breaking Changes

1. **Currency Configuration**
   ```dart
   // Old (v1.x)
   final result = converter.convert(amount, mainUnit: 'dollar', subUnit: 'cent');
   
   // New (v2.x)
   final result = converter.convert(amount, currency: CurrencyConfig.usDollar);
   ```

2. **Language Detection**
   ```dart
   // Old (v1.x)
   final converter = AmountToWords.fromLocale('fa');
   
   // New (v2.x) - Same API, but improved detection
   final converter = AmountToWords.fromContext(context); // Recommended
   ```

3. **Pluralization**
   ```dart
   // Old (v1.x) - Manual pluralization
   final unit = amount == 1 ? 'dollar' : 'dollars';
   
   // New (v2.x) - Automatic pluralization
   final unit = currency.getMainUnit(Language.en, count: amount);
   ```

#### Migration Steps

1. **Update Currency Usage**
   ```dart
   // Replace manual currency strings with CurrencyConfig
   // Search for: convert(amount, mainUnit: *, subUnit: *)
   // Replace with: convert(amount, currency: CurrencyConfig.*)
   ```

2. **Update Custom Currencies**
   ```dart
   // Old approach - passing strings
   converter.convert(amount, mainUnit: 'token', subUnit: 'bit');
   
   // New approach - create CurrencyConfig
   final tokenCurrency = CurrencyConfig(
     mainUnits: {Language.en: 'token'},
     subUnits: {Language.en: 'bit'},
   );
   converter.convert(amount, currency: tokenCurrency);
   ```

3. **Update Tests**
   ```dart
   // Old test expectations might need updates due to improved accuracy
   // Review test cases for pluralization and decimal handling
   ```

### Performance Improvements in v2.x

- 40% faster number conversion
- Reduced memory usage for large numbers
- Better caching for repeated conversions
- Optimized pluralization logic

---

This guide covers comprehensive usage of the Amount to Words package. For more specific examples, check the `/example` directory in the package repository.
