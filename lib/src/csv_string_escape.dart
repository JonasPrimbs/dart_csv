/// An enumeration of string escape characters.
final class CsvStringEscape {
  /// The character to escape strings with.
  final String escapeCharacter;

  /// Escapes strings with double quotes (").
  static const CsvStringEscape doubleQuote = CsvStringEscape._(r'"');

  /// Escapes strings with single quotes (').
  static const CsvStringEscape singleQuote = CsvStringEscape._('\'');

  /// Escapes strings with spaces ( ).
  static const CsvStringEscape space = CsvStringEscape._(' ');

  /// Escapes strings with a custom [escapeCharacter].
  ///
  /// Note that this [escapeCharacter] must be exactly one character!
  factory CsvStringEscape.custom(String escapeCharacter) =>
      CsvStringEscape._(escapeCharacter);

  /// Specifies a CSV string escape [escapeCharacter].
  const CsvStringEscape._(this.escapeCharacter)
      : assert(
          escapeCharacter.length == 1,
          'The "escapeCharacter" parameter must contain exactly one character!',
        );

  /// Escapes a [string].
  String escape(String string) {
    return '$escapeCharacter$string$escapeCharacter';
  }
}
