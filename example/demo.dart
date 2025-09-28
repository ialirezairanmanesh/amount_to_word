import 'package:amount_to_word/amount_to_word.dart';

void main() {
  print('🌟 Amount to Words Demo\n');
  
  // Demo numbers
  final numbers = [123, 1234, 12345, 123456, 1234567];
  
  // Persian Demo
  print('📝 Persian (Farsi) Examples:');
  final persianConverter = AmountToWords(Language.fa);
  for (final number in numbers) {
    print('$number → ${persianConverter.toWords(number)}');
  }
  print('');
  
  // English Demo
  print('📝 English Examples:');
  final englishConverter = AmountToWords(Language.en);
  for (final number in numbers) {
    print('$number → ${englishConverter.toWords(number)}');
  }
  print('');
  
  // Turkish Demo
  print('📝 Turkish Examples:');
  final turkishConverter = AmountToWords(Language.tr);
  for (final number in numbers) {
    print('$number → ${turkishConverter.toWords(number)}');
  }
  print('');
  
  // Currency Demo
  print('💰 Currency Examples:');
  final amounts = [1.0, 5.99, 100.50, 1000.0, 1234.56];
  
  print('\n💵 US Dollar:');
  for (final amount in amounts) {
    print('\$$amount → ${englishConverter.convert(amount, currency: CurrencyConfig.usDollar)}');
  }
  
  print('\n💶 Euro:');
  for (final amount in amounts) {
    print('€$amount → ${englishConverter.convert(amount, currency: CurrencyConfig.euro)}');
  }
  
  print('\n💴 Iranian Toman:');
  for (final amount in amounts) {
    final tomanAmount = (amount * 1000).round(); // Convert to toman
    print('$tomanAmount تومان → ${persianConverter.convert(tomanAmount, currency: CurrencyConfig.iranianToman)}');
  }
  
  print('\n💷 Turkish Lira:');
  for (final amount in amounts) {
    print('₺$amount → ${turkishConverter.convert(amount, currency: CurrencyConfig.turkishLira)}');
  }
  
  // Mixed Format Demo
  print('\n🔀 Mixed Format Examples:');
  final mixedNumbers = [2566, 12345, 100000];
  
  print('\nPersian Mixed:');
  for (final number in mixedNumbers) {
    print('$number → ${persianConverter.toMixed(number)}');
  }
  
  print('\nEnglish Mixed:');
  for (final number in mixedNumbers) {
    print('$number → ${englishConverter.toMixed(number)}');
  }
  
  print('\nTurkish Mixed:');
  for (final number in mixedNumbers) {
    print('$number → ${turkishConverter.toMixed(number)}');
  }
  
  print('\n✨ Demo completed! Check out the package on pub.dev: https://pub.dev/packages/amount_to_word');
}
