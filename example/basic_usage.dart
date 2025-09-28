import 'package:amount_to_word/amount_to_word.dart';

void main() {
  // Basic number to words conversion
  print('=== Basic Number to Words ===');
  
  // Persian
  final persianConverter = AmountToWords(Language.fa);
  print('Persian: ${persianConverter.toWords(12345)}'); // دوازده هزار و سیصد و چهل و پنج
  
  // English
  final englishConverter = AmountToWords(Language.en);
  print('English: ${englishConverter.toWords(12345)}'); // twelve thousand three hundred forty-five
  
  // Turkish
  final turkishConverter = AmountToWords(Language.tr);
  print('Turkish: ${turkishConverter.toWords(12345)}'); // on iki bin üç yüz kırk beş
  
  print('\n=== Decimal Numbers ===');
  print('Persian: ${persianConverter.toWords(123.45)}'); // یکصد و بیست و سه و چهل و پنج صدم
  print('English: ${englishConverter.toWords(123.45)}'); // one hundred twenty-three and forty-five hundredths
  print('Turkish: ${turkishConverter.toWords(123.45)}'); // yüz yirmi üç ve kırk beş yüzde
  
  print('\n=== Edge Cases ===');
  print('Zero (Persian): ${persianConverter.toWords(0)}'); // صفر
  print('Zero (English): ${englishConverter.toWords(0)}'); // zero
  print('Large Number: ${englishConverter.toWords(1234567890)}'); // one billion two hundred...
}
