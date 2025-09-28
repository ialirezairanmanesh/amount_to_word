/// Enumeration for different number display formats
enum NumberFormat {
  /// Pure words format: "دوهزار و پانصد و شصت و شش" (fa), "two thousand five hundred sixty-six" (en)
  words,
  
  /// Mixed format: language digits + language words
  /// Persian: "۲ هزار و ۵۶۶", English: "2 thousand 566", Turkish: "2 bin 566"
  mixed,
  
  /// Pure digits format in language-specific numerals
  /// Persian: "۲۵۶۶", English: "2566", Turkish: "2566"
  languageDigits,
  
  /// Latin digits: "2566" (for all languages)
  latinDigits,
}

/// Configuration for number formatting
class NumberFormatConfig {
  /// The display format to use
  final NumberFormat format;
  
  /// Whether to add commas for large numbers in digit formats
  final bool addCommas;
  
  /// Minimum number threshold for using mixed format
  /// Numbers below this will be displayed as words
  final int mixedFormatThreshold;
  
  const NumberFormatConfig({
    this.format = NumberFormat.words,
    this.addCommas = false,
    this.mixedFormatThreshold = 1000,
  });
  
  /// Default configuration for pure words
  static const words = NumberFormatConfig(
    format: NumberFormat.words,
  );
  
  /// Default configuration for mixed format
  static const mixed = NumberFormatConfig(
    format: NumberFormat.mixed,
    mixedFormatThreshold: 100,
  );
  
  /// Default configuration for language-specific digits
  static const languageDigits = NumberFormatConfig(
    format: NumberFormat.languageDigits,
    addCommas: true,
  );
  
  /// Default configuration for Latin digits
  static const latinDigits = NumberFormatConfig(
    format: NumberFormat.latinDigits,
    addCommas: true,
  );
}
