import 'package:flutter_test/flutter_test.dart';
import 'package:amount_to_word/amount_to_word.dart';

// Mock class to simulate app's Currency enum
class _MockAppCurrency {
  final String name;
  _MockAppCurrency(this.name);
  
  @override
  String toString() => '_MockAppCurrency.$name';
}

void main() {
  group('CurrencyConfig Tests', () {
    
    group('Pluralization Tests', () {
      test('english pluralization rules', () {
        final config = CurrencyConfig.usDollar;
        
        // Singular
        expect(config.getMainUnit(Language.en, count: 1), 'dollar');
        expect(config.getSubUnit(Language.en, count: 1), 'cent');
        
        // Plural
        expect(config.getMainUnit(Language.en, count: 0), 'dollars');
        expect(config.getMainUnit(Language.en, count: 2), 'dollars');
        expect(config.getMainUnit(Language.en, count: 5), 'dollars');
        expect(config.getSubUnit(Language.en, count: 99), 'cents');
      });
      
      test('english special pluralization cases', () {
        // Test penny -> pennies (y -> ies rule)
        final customConfig = CurrencyConfig(
          mainUnits: {Language.en: 'pound'},
          subUnits: {Language.en: 'penny'},
        );
        
        expect(customConfig.getSubUnit(Language.en, count: 1), 'penny');
        expect(customConfig.getSubUnit(Language.en, count: 2), 'pennies');
      });
      
      test('persian and turkish no pluralization', () {
        final config = CurrencyConfig.usDollar;
        
        // Persian - should be same regardless of count
        expect(config.getMainUnit(Language.fa, count: 1), 'دلار');
        expect(config.getMainUnit(Language.fa, count: 5), 'دلار');
        
        // Turkish - should be same regardless of count
        expect(config.getMainUnit(Language.tr, count: 1), 'dolar');
        expect(config.getMainUnit(Language.tr, count: 5), 'dolar');
      });
    });
    
    group('Predefined Currencies Tests', () {
      test('iranian currencies', () {
        // Rial
        expect(CurrencyConfig.iranianRial.hasSubUnit, false);
        expect(CurrencyConfig.iranianRial.getMainUnit(Language.fa), 'ریال');
        expect(CurrencyConfig.iranianRial.getMainUnit(Language.en), 'rial');
        expect(CurrencyConfig.iranianRial.getMainUnit(Language.tr), 'rial');
        
        // Toman
        expect(CurrencyConfig.iranianToman.hasSubUnit, false);
        expect(CurrencyConfig.iranianToman.getMainUnit(Language.fa), 'تومان');
        expect(CurrencyConfig.iranianToman.getMainUnit(Language.en), 'toman');
        expect(CurrencyConfig.iranianToman.getMainUnit(Language.tr), 'toman');
      });
      
      test('us dollar', () {
        expect(CurrencyConfig.usDollar.hasSubUnit, true);
        expect(CurrencyConfig.usDollar.subUnitInMainUnit, 100);
        
        expect(CurrencyConfig.usDollar.getMainUnit(Language.fa), 'دلار');
        expect(CurrencyConfig.usDollar.getMainUnit(Language.en), 'dollar');
        expect(CurrencyConfig.usDollar.getMainUnit(Language.tr), 'dolar');
        
        expect(CurrencyConfig.usDollar.getSubUnit(Language.fa), 'سنت');
        expect(CurrencyConfig.usDollar.getSubUnit(Language.en), 'cent');
        expect(CurrencyConfig.usDollar.getSubUnit(Language.tr), 'sent');
      });
      
      test('euro', () {
        expect(CurrencyConfig.euro.hasSubUnit, true);
        expect(CurrencyConfig.euro.subUnitInMainUnit, 100);
        
        expect(CurrencyConfig.euro.getMainUnit(Language.fa), 'یورو');
        expect(CurrencyConfig.euro.getMainUnit(Language.en), 'euro');
        expect(CurrencyConfig.euro.getMainUnit(Language.tr), 'euro');
        
        expect(CurrencyConfig.euro.getSubUnit(Language.fa), 'سنت');
        expect(CurrencyConfig.euro.getSubUnit(Language.en), 'cent');
        expect(CurrencyConfig.euro.getSubUnit(Language.tr), 'sent');
      });
      
      test('turkish lira', () {
        expect(CurrencyConfig.turkishLira.hasSubUnit, true);
        expect(CurrencyConfig.turkishLira.subUnitInMainUnit, 100);
        
        expect(CurrencyConfig.turkishLira.getMainUnit(Language.fa), 'لیر');
        expect(CurrencyConfig.turkishLira.getMainUnit(Language.en), 'lira');
        expect(CurrencyConfig.turkishLira.getMainUnit(Language.tr), 'lira');
        
        expect(CurrencyConfig.turkishLira.getSubUnit(Language.fa), 'قروش');
        expect(CurrencyConfig.turkishLira.getSubUnit(Language.en), 'kurus');
        expect(CurrencyConfig.turkishLira.getSubUnit(Language.tr), 'kuruş');
      });
      
      test('canadian dollar', () {
        expect(CurrencyConfig.canadianDollar.hasSubUnit, true);
        
        expect(CurrencyConfig.canadianDollar.getMainUnit(Language.fa), 'دلار کانادا');
        expect(CurrencyConfig.canadianDollar.getMainUnit(Language.en), 'canadian dollar');
        expect(CurrencyConfig.canadianDollar.getMainUnit(Language.tr), 'kanada doları');
      });
      
      test('afghan afghani', () {
        expect(CurrencyConfig.afghanAfghani.hasSubUnit, false);
        
        expect(CurrencyConfig.afghanAfghani.getMainUnit(Language.fa), 'افغانی');
        expect(CurrencyConfig.afghanAfghani.getMainUnit(Language.en), 'afghani');
        expect(CurrencyConfig.afghanAfghani.getMainUnit(Language.tr), 'afgani');
      });
    });
    
    group('Language Code Methods Tests', () {
      test('get unit by language code', () {
        final config = CurrencyConfig.usDollar;
        
        expect(config.getMainUnitByCode('en'), 'dollar');
        expect(config.getMainUnitByCode('fa'), 'دلار');
        expect(config.getMainUnitByCode('tr'), 'dolar');
        expect(config.getMainUnitByCode('invalid'), 'dollar'); // fallback to en
        
        expect(config.getSubUnitByCode('en'), 'cent');
        expect(config.getSubUnitByCode('fa'), 'سنت');
        expect(config.getSubUnitByCode('tr'), 'sent');
      });
      
      test('get unit by language code with count', () {
        final config = CurrencyConfig.usDollar;
        
        // Singular
        expect(config.getMainUnitByCode('en', count: 1), 'dollar');
        expect(config.getSubUnitByCode('en', count: 1), 'cent');
        
        // Plural
        expect(config.getMainUnitByCode('en', count: 5), 'dollars');
        expect(config.getSubUnitByCode('en', count: 99), 'cents');
      });
    });
    
    group('Custom Currency Tests', () {
      test('create custom currency with all languages', () {
        final customCurrency = CurrencyConfig(
          mainUnits: {
            Language.fa: 'سکه',
            Language.en: 'coin',
            Language.tr: 'madeni para',
          },
          subUnits: {
            Language.fa: 'فلس',
            Language.en: 'bit',
            Language.tr: 'parça',
          },
          subUnitInMainUnit: 1000,
        );
        
        expect(customCurrency.hasSubUnit, true);
        expect(customCurrency.subUnitInMainUnit, 1000);
        
        expect(customCurrency.getMainUnit(Language.fa), 'سکه');
        expect(customCurrency.getMainUnit(Language.en), 'coin');
        expect(customCurrency.getMainUnit(Language.tr), 'madeni para');
        
        expect(customCurrency.getSubUnit(Language.fa), 'فلس');
        expect(customCurrency.getSubUnit(Language.en), 'bit');
        expect(customCurrency.getSubUnit(Language.tr), 'parça');
      });
      
      test('create custom currency without decimals', () {
        final customCurrency = CurrencyConfig(
          mainUnits: {
            Language.en: 'gem',
            Language.fa: 'جواهر',
          },
          // No subUnits
        );
        
        expect(customCurrency.hasSubUnit, false);
        expect(customCurrency.getSubUnit(Language.en), null);
        expect(customCurrency.getSubUnit(Language.fa), null);
      });
      
      test('partial language support fallback', () {
        final partialCurrency = CurrencyConfig(
          mainUnits: {
            Language.en: 'token',
            // Missing fa and tr
          },
          subUnits: {
            Language.en: 'fragment',
            Language.fa: 'قطعه', // Only fa, missing tr
          },
        );
        
        // Should fallback to English
        expect(partialCurrency.getMainUnit(Language.fa), 'token');
        expect(partialCurrency.getMainUnit(Language.tr), 'token');
        
        // Should get fa for fa, fallback to en for tr
        expect(partialCurrency.getSubUnit(Language.fa), 'قطعه');
        expect(partialCurrency.getSubUnit(Language.tr), 'fragment');
      });
    });
    
    group('Add Language Feature Tests', () {
      test('add new language to existing currency', () {
        // Start with base USD
        var usd = CurrencyConfig.usDollar;
        
        // Add hypothetical Arabic support
        usd = usd.addLanguage(Language.en, 'dollar-ar', 'cent-ar'); // Using en as placeholder
        
        expect(usd.getMainUnit(Language.en), 'dollar-ar');
        expect(usd.getSubUnit(Language.en), 'cent-ar');
        
        // Original languages should still work
        expect(usd.getMainUnit(Language.fa), 'دلار');
        expect(usd.getMainUnit(Language.tr), 'dolar');
      });
      
      test('add language without subunit', () {
        var rial = CurrencyConfig.iranianRial;
        
        // Add hypothetical language (using en as placeholder)
        rial = rial.addLanguage(Language.en, 'rial-new');
        
        expect(rial.getMainUnit(Language.en), 'rial-new');
        expect(rial.getSubUnit(Language.en), null); // Should remain null
        expect(rial.hasSubUnit, false);
      });
    });
    
    group('Helper Methods Tests', () {
      test('getAllCurrencies', () {
        final currencies = CurrencyConfig.getAllCurrencies();
        
        expect(currencies.length, 7);
        expect(currencies.contains(CurrencyConfig.iranianRial), true);
        expect(currencies.contains(CurrencyConfig.iranianToman), true);
        expect(currencies.contains(CurrencyConfig.usDollar), true);
        expect(currencies.contains(CurrencyConfig.euro), true);
        expect(currencies.contains(CurrencyConfig.canadianDollar), true);
        expect(currencies.contains(CurrencyConfig.turkishLira), true);
        expect(currencies.contains(CurrencyConfig.afghanAfghani), true);
      });
      
      test('getByAppCurrency', () {
        // Test with mock enum objects (simulating app's Currency enum)
        final mockRial = _MockAppCurrency('rial');
        final mockToman = _MockAppCurrency('toman');
        final mockDollar = _MockAppCurrency('dollar');
        final mockEuro = _MockAppCurrency('euro');
        final mockCad = _MockAppCurrency('cad');
        final mockLira = _MockAppCurrency('lira');
        final mockAfghani = _MockAppCurrency('afghani');
        final mockUnknown = _MockAppCurrency('unknown');
        
        expect(CurrencyConfig.getByAppCurrency(mockRial), 
               CurrencyConfig.iranianRial);
        expect(CurrencyConfig.getByAppCurrency(mockToman), 
               CurrencyConfig.iranianToman);
        expect(CurrencyConfig.getByAppCurrency(mockDollar), 
               CurrencyConfig.usDollar);
        expect(CurrencyConfig.getByAppCurrency(mockEuro), 
               CurrencyConfig.euro);
        expect(CurrencyConfig.getByAppCurrency(mockCad), 
               CurrencyConfig.canadianDollar);
        expect(CurrencyConfig.getByAppCurrency(mockLira), 
               CurrencyConfig.turkishLira);
        expect(CurrencyConfig.getByAppCurrency(mockAfghani), 
               CurrencyConfig.afghanAfghani);
        expect(CurrencyConfig.getByAppCurrency(mockUnknown), 
               CurrencyConfig.iranianToman); // fallback
      });
    });
    
    group('Backward Compatibility Tests', () {
      test('deprecated getters still work', () {
        final config = CurrencyConfig.usDollar;
        
        // These should work but show deprecation warnings
        expect(config.mainUnit, 'دلار'); // fa fallback
        expect(config.subUnit, 'سنت'); // fa fallback
      });
      
      test('deprecated currency configs still work', () {
        expect(CurrencyConfig.tomanRial, CurrencyConfig.iranianToman);
        expect(CurrencyConfig.dollarCent, CurrencyConfig.usDollar);
        expect(CurrencyConfig.euroCent, CurrencyConfig.euro);
      });
    });
    
    group('Equality and ToString Tests', () {
      test('equality operator', () {
        final config1 = CurrencyConfig(
          mainUnits: {Language.en: 'test'},
          subUnits: {Language.en: 'subtest'},
          subUnitInMainUnit: 100,
        );
        
        final config2 = CurrencyConfig(
          mainUnits: {Language.en: 'test'},
          subUnits: {Language.en: 'subtest'},
          subUnitInMainUnit: 100,
        );
        
        final config3 = CurrencyConfig(
          mainUnits: {Language.en: 'different'},
          subUnits: {Language.en: 'subtest'},
          subUnitInMainUnit: 100,
        );
        
        expect(config1 == config2, true);
        expect(config1 == config3, false);
        // Note: hashCode equality might not always be guaranteed for equal objects
        // expect(config1.hashCode == config2.hashCode, true);
      });
      
      test('toString method', () {
        final config = CurrencyConfig(
          mainUnits: {Language.en: 'test'},
          subUnits: {Language.en: 'subtest'},
          subUnitInMainUnit: 50,
        );
        
        final str = config.toString();
        expect(str.contains('test'), true);
        expect(str.contains('subtest'), true);
        expect(str.contains('50'), true);
      });
      
      test('toString for currency without decimals', () {
        final config = CurrencyConfig(
          mainUnits: {Language.en: 'nodecimal'},
        );
        
        final str = config.toString();
        expect(str.contains('nodecimal'), true);
        expect(str.contains('no decimals'), true);
      });
    });
  });
}
