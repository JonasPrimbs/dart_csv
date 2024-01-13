/// An enumeration of modes when to escape strings in a CSV file export.
enum CsvStringEscapeModes {
  /// String-escapes all fields.
  all,

  /// String-escapes all strings.
  allStrings,

  /// String-escapes only string fields and only if required.
  whenRequired,
}
