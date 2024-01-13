/// An enumeration of new line types of a CSV file export.
final class CsvNewLineTypes {
  /// The Windows standard for a new line.
  /// Consisting of a carriage return (CR) and line feed (LF).
  static const CsvNewLineTypes crlf = CsvNewLineTypes._('\r\n');

  /// The Unix standard for a new line.
  /// Consisting of a line feed (LF).
  static const CsvNewLineTypes lf = CsvNewLineTypes._('\n');

  /// The new line string.
  final String newLine;

  /// A CSV [newLine] type.
  const CsvNewLineTypes._(this.newLine);
}
