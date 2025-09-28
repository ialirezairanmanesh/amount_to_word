import 'package:amount_to_word/amount_to_word.dart';

void main() {
  print('=== Currency Conversion Examples ===');
  
  // Create converters for different languages
  final persianConverter = AmountToWords(Language.fa);
  final englishConverter = AmountToWords(Language.en);
  final turkishConverter = AmountToWords(Language.tr);
  
  print('\n--- Iranian Currencies ---');
  
  // Iranian Rial (no decimals)
  print('1000 Rial (FA): ${persianConverter.convert(1000, currency: CurrencyConfig.iranianRial)}');
  print('1000 Rial (EN): ${englishConverter.convert(1000, currency: CurrencyConfig.iranianRial)}');
  
  // Iranian Toman (no decimals)
  print('500 Toman (FA): ${persianConverter.convert(500, currency: CurrencyConfig.iranianToman)}');
  print('500 Toman (EN): ${englishConverter.convert(500, currency: CurrencyConfig.iranianToman)}');
  
  print('\n--- International Currencies with Decimals ---');
  
  // US Dollar with cents
  print('123.45 USD (EN): ${englishConverter.convert(123.45, currency: CurrencyConfig.usDollar)}');
  print('123.45 USD (FA): ${persianConverter.convert(123.45, currency: CurrencyConfig.usDollar)}');
  print('123.45 USD (TR): ${turkishConverter.convert(123.45, currency: CurrencyConfig.usDollar)}');
  
  // Euro with cents
  print('89.99 EUR (EN): ${englishConverter.convert(89.99, currency: CurrencyConfig.euro)}');
  print('89.99 EUR (FA): ${persianConverter.convert(89.99, currency: CurrencyConfig.euro)}');
  
  // Turkish Lira with kuruş
  print('456.78 TRY (TR): ${turkishConverter.convert(456.78, currency: CurrencyConfig.turkishLira)}');
  print('456.78 TRY (EN): ${englishConverter.convert(456.78, currency: CurrencyConfig.turkishLira)}');
  
  print('\n--- Plural/Singular Examples (English) ---');
  
  // Singular
  print('1 Dollar: ${englishConverter.convert(1, currency: CurrencyConfig.usDollar)}'); // one dollar
  print('1.01 USD: ${englishConverter.convert(1.01, currency: CurrencyConfig.usDollar)}'); // one dollar and one cent
  
  // Plural
  print('5 Dollars: ${englishConverter.convert(5, currency: CurrencyConfig.usDollar)}'); // five dollars
  print('2.99 USD: ${englishConverter.convert(2.99, currency: CurrencyConfig.usDollar)}'); // two dollars and ninety-nine cents
  
  print('\n--- All Supported Currencies ---');
  
  final amount = 100.50;
  final currencies = [
    ('Iranian Rial', CurrencyConfig.iranianRial),
    ('Iranian Toman', CurrencyConfig.iranianToman),
    ('US Dollar', CurrencyConfig.usDollar),
    ('Euro', CurrencyConfig.euro),
    ('Canadian Dollar', CurrencyConfig.canadianDollar),
    ('Turkish Lira', CurrencyConfig.turkishLira),
    ('Afghan Afghani', CurrencyConfig.afghanAfghani),
  ];
  
  for (final (name, config) in currencies) {
    print('$name: ${englishConverter.convert(amount, currency: config)}');
  }
}
