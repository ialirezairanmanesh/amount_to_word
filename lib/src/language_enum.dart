/// Supported languages for number to words conversion
enum Language {
  /// Persian/Farsi language
  fa('fa', 'Persian'),
  
  /// English language
  en('en', 'English'),
  
  /// Turkish language
  tr('tr', 'Turkish');

  const Language(this.code, this.name);

  /// Language code (e.g., 'fa', 'en')
  final String code;
  
  /// Language display name
  final String name;

  /// Get Language from locale code
  static Language? fromCode(String code) {
    for (final lang in Language.values) {
      if (lang.code == code) return lang;
    }
    return null;
  }
}