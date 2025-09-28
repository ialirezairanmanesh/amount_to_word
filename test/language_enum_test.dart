import 'package:flutter_test/flutter_test.dart';
import 'package:amount_to_word/amount_to_word.dart';

void main() {
  group('Language Enum Tests', () {
    
    test('all supported languages', () {
      expect(Language.values.length, 3);
      expect(Language.values.contains(Language.fa), true);
      expect(Language.values.contains(Language.en), true);
      expect(Language.values.contains(Language.tr), true);
    });
    
    test('language properties', () {
      // Persian
      expect(Language.fa.code, 'fa');
      expect(Language.fa.name, 'Persian');
      
      // English
      expect(Language.en.code, 'en');
      expect(Language.en.name, 'English');
      
      // Turkish
      expect(Language.tr.code, 'tr');
      expect(Language.tr.name, 'Turkish');
    });
    
    test('fromCode method', () {
      // Valid codes
      expect(Language.fromCode('fa'), Language.fa);
      expect(Language.fromCode('en'), Language.en);
      expect(Language.fromCode('tr'), Language.tr);
      
      // Invalid codes
      expect(Language.fromCode('invalid'), null);
      expect(Language.fromCode('ar'), null);
      expect(Language.fromCode(''), null);
      expect(Language.fromCode('FR'), null); // Case sensitive
    });
    
    test('fromCode case sensitivity', () {
      // Should be case sensitive
      expect(Language.fromCode('FA'), null);
      expect(Language.fromCode('EN'), null);
      expect(Language.fromCode('TR'), null);
      expect(Language.fromCode('Fa'), null);
    });
    
    test('language codes are unique', () {
      final codes = Language.values.map((lang) => lang.code).toSet();
      expect(codes.length, Language.values.length);
    });
    
    test('language names are unique', () {
      final names = Language.values.map((lang) => lang.name).toSet();
      expect(names.length, Language.values.length);
    });
    
    test('toString representation', () {
      expect(Language.fa.toString(), 'Language.fa');
      expect(Language.en.toString(), 'Language.en');
      expect(Language.tr.toString(), 'Language.tr');
    });
  });
}
