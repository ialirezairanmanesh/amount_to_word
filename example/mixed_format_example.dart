import 'package:amount_to_word/amount_to_word.dart';

void main() {
  print('=== Mixed Format Examples ===');
  
  final number = 2566;
  final amount = 2566.75;
  
  print('\n--- Number: $number ---');
  
  // Persian
  final faConverter = AmountToWords(Language.fa);
  print('Persian Words: ${faConverter.toWords(number)}');
  print('Persian Mixed: ${faConverter.toMixed(number)}');
  print('Persian Digits: ${NumberFormatter.formatLanguageNumber(number, Language.fa)}');
  
  // English
  final enConverter = AmountToWords(Language.en);
  print('English Words: ${enConverter.toWords(number)}');
  print('English Mixed: ${enConverter.toMixed(number)}');
  print('English Digits: ${NumberFormatter.formatLanguageNumber(number, Language.en)}');
  
  // Turkish
  final trConverter = AmountToWords(Language.tr);
  print('Turkish Words: ${trConverter.toWords(number)}');
  print('Turkish Mixed: ${trConverter.toMixed(number)}');
  print('Turkish Digits: ${NumberFormatter.formatLanguageNumber(number, Language.tr)}');
  
  print('\n--- Amount with Currency: $amount USD ---');
  
  // Persian with USD
  print('Persian Currency Words: ${faConverter.convert(amount, currency: CurrencyConfig.usDollar)}');
  print('Persian Currency Mixed: ${faConverter.convertToMixed(amount, currency: CurrencyConfig.usDollar)}');
  
  // English with USD
  print('English Currency Words: ${enConverter.convert(amount, currency: CurrencyConfig.usDollar)}');
  print('English Currency Mixed: ${enConverter.convertToMixed(amount, currency: CurrencyConfig.usDollar)}');
  
  // Turkish with USD
  print('Turkish Currency Words: ${trConverter.convert(amount, currency: CurrencyConfig.usDollar)}');
  print('Turkish Currency Mixed: ${trConverter.convertToMixed(amount, currency: CurrencyConfig.usDollar)}');
  
  print('\n--- Different Threshold Examples ---');
  
  final smallNumber = 95;
  final mediumNumber = 1234;
  final largeNumber = 123456;
  
  // Test different thresholds
  final lowThreshold = NumberFormatConfig(
    format: NumberFormat.mixed,
    mixedFormatThreshold: 50,
  );
  
  final highThreshold = NumberFormatConfig(
    format: NumberFormat.mixed,
    mixedFormatThreshold: 1000,
  );
  
  print('Small Number ($smallNumber):');
  print('  Low Threshold: ${faConverter.toMixed(smallNumber, formatConfig: lowThreshold)}');
  print('  High Threshold: ${faConverter.toMixed(smallNumber, formatConfig: highThreshold)}');
  
  print('Medium Number ($mediumNumber):');
  print('  Low Threshold: ${faConverter.toMixed(mediumNumber, formatConfig: lowThreshold)}');
  print('  High Threshold: ${faConverter.toMixed(mediumNumber, formatConfig: highThreshold)}');
  
  print('Large Number ($largeNumber):');
  print('  Low Threshold: ${faConverter.toMixed(largeNumber, formatConfig: lowThreshold)}');
  print('  High Threshold: ${faConverter.toMixed(largeNumber, formatConfig: highThreshold)}');
  
  print('\n--- Persian Digit Conversion Examples ---');
  
  final numbers = [0, 123, 1234, 12345, 123456];
  for (final num in numbers) {
    print('$num -> ${NumberFormatter.formatLanguageNumber(num, Language.fa, addCommas: true)}');
  }
  
  print('\n--- Mixed Format with Iranian Currencies ---');
  
  final iranAmount = 15000;
  
  print('$iranAmount Toman:');
  print('  Words: ${faConverter.convert(iranAmount, currency: CurrencyConfig.iranianToman)}');
  print('  Mixed: ${faConverter.convertToMixed(iranAmount, currency: CurrencyConfig.iranianToman)}');
  
  print('$iranAmount Rial:');
  print('  Words: ${faConverter.convert(iranAmount, currency: CurrencyConfig.iranianRial)}');
  print('  Mixed: ${faConverter.convertToMixed(iranAmount, currency: CurrencyConfig.iranianRial)}');
}
