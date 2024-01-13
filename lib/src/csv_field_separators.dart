/// An enumeration of CSV field separators.
final class CsvFieldSeparators {
  /// Separates fields with a comma (,).
  static const CsvFieldSeparators comma = CsvFieldSeparators._(',');

  /// Separates fields with a semicolon (;).
  static const CsvFieldSeparators semicolon = CsvFieldSeparators._(';');

  /// Separates fields with a colon (:);
  static const CsvFieldSeparators colon = CsvFieldSeparators._(':');

  /// Separates fields with a tabulator (\t).
  static const CsvFieldSeparators tab = CsvFieldSeparators._('\t');

  /// Separates fields with a space character ( ).
  static const CsvFieldSeparators space = CsvFieldSeparators._(' ');

  /// Separates fields with an equal sign (=).
  static const CsvFieldSeparators equalSign = CsvFieldSeparators._('=');

  /// Separates fields with a pipe symbol (|).
  static const CsvFieldSeparators pipe = CsvFieldSeparators._('|');

  /// Separates fields with a custom [delimiter].
  ///
  /// Note that this delimiter must be exactly on character!
  factory CsvFieldSeparators.custom(String delimiter) =>
      CsvFieldSeparators._(delimiter);

  /// The delimiter to separate fields with.
  final String delimiter;

  /// Specifies a CSV field [delimiter].
  const CsvFieldSeparators._(this.delimiter)
      : assert(
          delimiter.length == 1,
          'The "delimiter" parameter must be exactly one character!',
        );
}
