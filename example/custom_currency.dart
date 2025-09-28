import 'package:amount_to_word/amount_to_word.dart';

// Mock class to simulate app's Currency enum
class _MockAppCurrency {
  final String name;
  _MockAppCurrency(this.name);
  
  @override
  String toString() => 'AppCurrency.$name';
}

void main() {
  print('=== Custom Currency Configuration Examples ===');
  
  // Example 1: Adding a new language to existing currency
  print('\n--- Adding Arabic to USD ---');
  final usdWithArabic = CurrencyConfig.usDollar.addLanguage(
    Language.en, // Since we don't have Arabic in enum yet, using English as example
    'dollar (arabic)',
    'cent (arabic)',
  );
  
  final converter = AmountToWords(Language.en);
  print('USD with custom Arabic: ${converter.convert(123.45, currency: usdWithArabic)}');
  
  // Example 2: Creating completely custom currency
  print('\n--- Custom Cryptocurrency ---');
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
    subUnitInMainUnit: 100000000, // 100 million satoshis = 1 bitcoin
  );
  
  print('English: ${AmountToWords(Language.en).convert(1.5, currency: bitcoin)}');
  print('Persian: ${AmountToWords(Language.fa).convert(1.5, currency: bitcoin)}');
  print('Turkish: ${AmountToWords(Language.tr).convert(1.5, currency: bitcoin)}');
  
  // Example 3: Currency without decimals (like Iranian currencies)
  print('\n--- Custom Currency without Decimals ---');
  final customCoin = CurrencyConfig(
    mainUnits: {
      Language.en: 'goldcoin',
      Language.fa: 'سکه‌طلا',
      Language.tr: 'altın',
    },
    // No subUnits = no decimal support
  );
  
  print('Gold coin (EN): ${AmountToWords(Language.en).convert(42, currency: customCoin)}');
  print('Gold coin (FA): ${AmountToWords(Language.fa).convert(42, currency: customCoin)}');
  
  // Example 4: Getting currency by app's enum (simulation)
  print('\n--- Getting Currency by App Enum ---');
  
  // Simulate app's Currency enum values using mock objects
  final appCurrencies = [
    _MockAppCurrency('rial'),
    _MockAppCurrency('toman'),
    _MockAppCurrency('dollar'),
    _MockAppCurrency('euro'),
    _MockAppCurrency('lira'),
  ];
  
  for (final appCurrency in appCurrencies) {
    final config = CurrencyConfig.getByAppCurrency(appCurrency);
    print('${appCurrency.name}: ${converter.convert(100, currency: config)}');
  }
  
  // Example 5: Pluralization examples
  print('\n--- Pluralization Examples ---');
  
  final englishConverter = AmountToWords(Language.en);
  
  // Test various amounts to show singular/plural
  final testAmounts = [0.01, 1, 1.01, 2, 5.99, 21, 100];
  
  for (final amount in testAmounts) {
    print('$amount USD: ${englishConverter.convert(amount, currency: CurrencyConfig.usDollar)}');
  }
  
  print('\n--- Currency Helper Methods ---');
  
  // Check if currency has decimals
  print('USD has decimals: ${CurrencyConfig.usDollar.hasSubUnit}');
  print('Iranian Rial has decimals: ${CurrencyConfig.iranianRial.hasSubUnit}');
  
  // Get all supported currencies
  print('\nAll supported currencies:');
  for (final currency in CurrencyConfig.getAllCurrencies()) {
    final mainUnit = currency.getMainUnit(Language.en);
    final hasDecimals = currency.hasSubUnit ? 'with decimals' : 'no decimals';
    print('- $mainUnit ($hasDecimals)');
  }
}
