import 'package:flutter_test/flutter_test.dart';
import 'package:amount_to_word/amount_to_word.dart';

// Mock class to simulate app's Currency enum
class _MockEnum {
  final String name;
  _MockEnum(this.name);
  
  @override
  String toString() => 'MockEnum.$name';
}

void main() {
  group('AmountToWords Tests', () {
    
    group('Persian Converter Tests', () {
      late AmountToWords converter;
      
      setUp(() {
        converter = AmountToWords(Language.fa);
      });
      
      test('basic numbers', () {
      expect(converter.toWords(0), 'صفر');
      expect(converter.toWords(1), 'یک');
      expect(converter.toWords(10), 'ده');
      expect(converter.toWords(25), 'بیست و پنج');
      expect(converter.toWords(100), 'صد');
      expect(converter.toWords(1000), 'یک هزار');
      expect(converter.toWords(1000000), 'یک میلیون');
    });

      test('complex numbers', () {
        expect(converter.toWords(9900), 'نه هزار و نهصد');
        expect(converter.toWords(123456), 'صد و بیست و سه هزار و چهارصد و پنجاه و شش');
      });
      
      test('decimal numbers', () {
        expect(converter.toWords(10.5), 'ده و پنج دهم');
        expect(converter.toWords(10.25), 'ده و بیست و پنج صدم');
      });
      
      test('edge cases', () {
        expect(converter.toWords(10000.0), 'ده هزار'); // No trailing "و"
        expect(converter.toWords(0.0), 'صفر');
      });
    });
    
    group('English Converter Tests', () {
      late AmountToWords converter;
      
      setUp(() {
        converter = AmountToWords(Language.en);
      });
      
      test('basic numbers', () {
      expect(converter.toWords(0), 'zero');
      expect(converter.toWords(1), 'one');
      expect(converter.toWords(10), 'ten');
      expect(converter.toWords(25), 'twenty-five');
      expect(converter.toWords(100), 'one hundred');
      expect(converter.toWords(1000), 'one thousand');
      expect(converter.toWords(1000000), 'one million');
    });

      test('complex numbers', () {
        expect(converter.toWords(9900), 'nine thousand nine hundred');
        expect(converter.toWords(123456), 'one hundred twenty-three thousand four hundred fifty-six');
      });
      
      test('decimal numbers', () {
        expect(converter.toWords(10.5), 'ten and fifty tenths');
        expect(converter.toWords(10.25), 'ten and twenty-five hundredths');
      });
      
      test('edge cases', () {
        expect(converter.toWords(10000.0), 'ten thousand'); // No trailing "and"
        expect(converter.toWords(0.0), 'zero');
      });
    });
    
    group('Turkish Converter Tests', () {
      late AmountToWords converter;
      
      setUp(() {
        converter = AmountToWords(Language.tr);
      });
      
      test('basic numbers', () {
        expect(converter.toWords(0), 'sıfır');
        expect(converter.toWords(1), 'bir');
        expect(converter.toWords(10), 'on');
        expect(converter.toWords(25), 'yirmi beş');
        expect(converter.toWords(100), 'yüz');
        expect(converter.toWords(1000), 'bin'); // Special case: no "bir" before "bin"
        expect(converter.toWords(1000000), 'bir milyon');
      });
      
      test('special turkish rules', () {
        expect(converter.toWords(100), 'yüz'); // No "bir" before "yüz"
        expect(converter.toWords(2000), 'iki bin');
        expect(converter.toWords(2100), 'iki bin yüz');
      });
    });
    
    group('Currency Tests', () {
      test('iranian currencies (no decimals)', () {
        final faConverter = AmountToWords(Language.fa);
        final enConverter = AmountToWords(Language.en);
        
        // Iranian Rial
        expect(faConverter.convert(1000, currency: CurrencyConfig.iranianRial), 
               'یک هزار ریال');
        expect(enConverter.convert(1000, currency: CurrencyConfig.iranianRial), 
               'one thousand rials');
        
        // Iranian Toman
        expect(faConverter.convert(500, currency: CurrencyConfig.iranianToman), 
               'پانصد تومان');
        expect(enConverter.convert(500, currency: CurrencyConfig.iranianToman), 
               'five hundred tomans');
        
        // Test that decimals are ignored for non-decimal currencies
        expect(faConverter.convert(100.99, currency: CurrencyConfig.iranianRial), 
               'صد ریال');
      });
      
      test('international currencies (with decimals)', () {
        final enConverter = AmountToWords(Language.en);
        
        // US Dollar
        expect(enConverter.convert(123.45, currency: CurrencyConfig.usDollar), 
               'one hundred twenty-three dollars and forty-five cents');
        
        // Euro
        expect(enConverter.convert(89.99, currency: CurrencyConfig.euro), 
               'eighty-nine euros and ninety-nine cents');
        
        // Turkish Lira
        expect(enConverter.convert(456.78, currency: CurrencyConfig.turkishLira), 
               'four hundred fifty-six liras and seventy-eight kuruses');
      });
      
      test('pluralization rules', () {
        final enConverter = AmountToWords(Language.en);
        
        // Singular
        expect(enConverter.convert(1, currency: CurrencyConfig.usDollar), 
               'one dollar');
        expect(enConverter.convert(1.01, currency: CurrencyConfig.usDollar), 
               'one dollar and one cent');
        
        // Plural
        expect(enConverter.convert(5, currency: CurrencyConfig.usDollar), 
               'five dollars');
        expect(enConverter.convert(2.99, currency: CurrencyConfig.usDollar), 
               'two dollars and ninety-nine cents');
        
        // Zero should be plural in English
        expect(enConverter.convert(0, currency: CurrencyConfig.usDollar), 
               'zero dollars');
      });
      
      test('multilingual currency support', () {
        final faConverter = AmountToWords(Language.fa);
        final enConverter = AmountToWords(Language.en);
        final trConverter = AmountToWords(Language.tr);
        
        // Test same currency in different languages
        const amount = 100.50;
        
        expect(faConverter.convert(amount, currency: CurrencyConfig.usDollar), 
               'صد دلار و پنجاه سنت');
        expect(enConverter.convert(amount, currency: CurrencyConfig.usDollar), 
               'one hundred dollars and fifty cents');
        expect(trConverter.convert(amount, currency: CurrencyConfig.usDollar), 
               'yüz dolar ve elli sent');
      });
    });
    
    group('Language Detection Tests', () {
      test('fromLocale method', () {
      expect(AmountToWords.fromLocale('fa').language, Language.fa);
      expect(AmountToWords.fromLocale('en').language, Language.en);
        expect(AmountToWords.fromLocale('tr').language, Language.tr);
      expect(AmountToWords.fromLocale('unknown').language, Language.en); // fallback
      });
      
      test('language enum', () {
        expect(Language.fromCode('fa'), Language.fa);
        expect(Language.fromCode('en'), Language.en);
        expect(Language.fromCode('tr'), Language.tr);
        expect(Language.fromCode('invalid'), null);
      });
    });
    
    group('Currency Configuration Tests', () {
      test('currency helper methods', () {
        // Check decimal support
        expect(CurrencyConfig.usDollar.hasSubUnit, true);
        expect(CurrencyConfig.iranianRial.hasSubUnit, false);
        expect(CurrencyConfig.iranianToman.hasSubUnit, false);
        
        // Get all currencies
        final currencies = CurrencyConfig.getAllCurrencies();
        expect(currencies.length, 7); // Should have 7 predefined currencies
        expect(currencies.contains(CurrencyConfig.usDollar), true);
        expect(currencies.contains(CurrencyConfig.iranianToman), true);
      });
      
      test('currency by app enum', () {
        // Create mock enum-like objects to test getByAppCurrency
        final testRial = _MockEnum('rial');
        final testToman = _MockEnum('toman'); 
        final testDollar = _MockEnum('dollar');
        final testEuro = _MockEnum('euro');
        final testUnknown = _MockEnum('unknown');
        
        expect(CurrencyConfig.getByAppCurrency(testRial), 
               CurrencyConfig.iranianRial);
        expect(CurrencyConfig.getByAppCurrency(testToman), 
               CurrencyConfig.iranianToman);
        expect(CurrencyConfig.getByAppCurrency(testDollar), 
               CurrencyConfig.usDollar);
        expect(CurrencyConfig.getByAppCurrency(testEuro), 
               CurrencyConfig.euro);
        expect(CurrencyConfig.getByAppCurrency(testUnknown), 
               CurrencyConfig.iranianToman); // fallback
      });
      
      test('custom currency creation', () {
        final customCurrency = CurrencyConfig(
          mainUnits: {
            Language.en: 'customcoin',
            Language.fa: 'سکه‌سفارشی',
          },
          subUnits: {
            Language.en: 'subcoin',
            Language.fa: 'زیرسکه',
          },
        );
        
        final enConverter = AmountToWords(Language.en);
        expect(enConverter.convert(5.25, currency: customCurrency), 
               'five customcoins and twenty-five subcoins');
      });
      
      test('add language to existing currency', () {
        // This tests the extensibility feature
        final usdExtended = CurrencyConfig.usDollar.addLanguage(
          Language.fa, // Using existing language as example
          'دلار جدید',
          'سنت جدید',
        );
        
        expect(usdExtended.getMainUnit(Language.fa), 'دلار جدید');
        expect(usdExtended.getSubUnit(Language.fa), 'سنت جدید');
      });
    });
    
    group('Edge Cases and Error Handling', () {
      test('very large numbers', () {
        final converter = AmountToWords(Language.en);
        
        // Test trillion
        expect(converter.toWords(1000000000000), 'one trillion');
        
        // Test complex large number
        final result = converter.toWords(1234567890123);
        expect(result.contains('trillion'), true);
        expect(result.contains('billion'), true);
        expect(result.contains('million'), true);
      });
      
      test('precision handling', () {
        final converter = AmountToWords(Language.en);
        
        // Test that precision is limited
        expect(converter.toWords(1.999), 'one and ninety-nine hundredths');
        expect(converter.toWords(1.9999), 'one and ninety-nine hundredths'); // Should limit to 2 decimal places
      });
      
      test('zero and negative handling', () {
        final converter = AmountToWords(Language.en);
        
        expect(converter.toWords(0), 'zero');
        expect(converter.toWords(0.0), 'zero');
        
        // Negative numbers should throw
        expect(() => converter.toWords(-1), throwsArgumentError);
      });
    });
  });
}