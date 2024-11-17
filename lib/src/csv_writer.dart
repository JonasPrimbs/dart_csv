import 'dart:io';

import './csv_configuration.dart';
import './csv_string_escape_modes.dart';
import './csv_write_exception.dart';

final class CsvWriter {
  /// The CSV export configuration.
  final CsvConfiguration configuration;

  /// The IO sink to write to the file.
  final IOSink _sink;

  /// Whether the title of the CSV file has already been defined.
  bool get hasTitle => _wroteTitles;

  /// Whether the title row was already defined.
  bool _wroteTitles = false;

  /// Whether any row has already been defined.
  bool _firstRow = true;

  /// A writer to abstract writing a CSV file using an active IO [sink] using a
  /// CSV [configuration] which defaults to RFC 7111.
  CsvWriter(
    IOSink sink, [
    CsvConfiguration? configuration,
  ])  : _sink = sink,
        configuration = configuration ?? CsvConfiguration.rfc7111();

  /// Writes a row of [values].
  ///
  /// Throws [CsvWriteException] if writing fails.
  void _writeRow(Iterable<dynamic> values) {
    // Serialize strings.
    final strings = values.map((value) {
      switch (value) {
        // Convert string:
        case String stringValue:
          // Remove blacklisted values.
          if (configuration.disallowedCharacters != null) {
            stringValue = stringValue.replaceAll(
                configuration.disallowedCharacters!, r'');
          }

          // Remove not-whitelisted values.
          if (configuration.allowedCharacters != null) {
            stringValue = stringValue.splitMapJoin(
              configuration.allowedCharacters!,
              onMatch: (match) => '$match',
              onNonMatch: (_) => '',
            );
          }

          // Escape formula by adding a leading space character ( ).
          // See: https://owasp.org/www-community/attacks/CSV_Injection
          if (configuration.escapeMacros &&
              stringValue.startsWith(RegExp(
                  '(${RegExp.escape('=')}|${RegExp.escape('+')}|${RegExp.escape('-')}|${RegExp.escape('@')}|${RegExp.escape('\t')}|${RegExp.escape('\r')})'))) {
            stringValue = ' $stringValue';
          }

          // Escape string escape characters.
          stringValue = stringValue.replaceAll(
              configuration.stringEscape.escapeCharacter,
              '${configuration.stringEscape.escapeCharacter}${configuration.stringEscape.escapeCharacter}');

          // Escape strings if required.
          switch (configuration.stringEscapeMode) {
            case CsvStringEscapeModes.all:
            case CsvStringEscapeModes.allStrings:
              // Escape strings.
              return configuration.stringEscape.escape(stringValue);
            case CsvStringEscapeModes.whenRequired:
              // Check whether a string escape character, a field separator, or a new line is present in the string.
              if (stringValue.contains(
                RegExp(
                  '(${RegExp.escape(configuration.stringEscape.escapeCharacter)}|${RegExp.escape(configuration.fieldSeparator.delimiter)}|${RegExp.escape(configuration.newLine.newLine)})',
                ),
              )) {
                // Escape strings.
                return configuration.stringEscape.escape(stringValue);
              } else {
                // Do not escape strings.
                return stringValue;
              }
          }
        // Convert number:
        case num numberValue:
          if (configuration.stringEscapeMode == CsvStringEscapeModes.all) {
            // Escape string.
            return configuration.stringEscape.escape(
              configuration.numberFormat?.format(numberValue) ??
                  numberValue.toString(),
            );
          } else {
            // Do not escape string.
            return configuration.numberFormat?.format(numberValue) ??
                numberValue.toString();
          }
        // Convert boolean:
        case bool booleanValue:
          if (configuration.stringEscapeMode == CsvStringEscapeModes.all) {
            // Escape string.
            return configuration.stringEscape
                .escape(booleanValue ? 'TRUE' : 'FALSE');
          } else {
            // Do not escape string.
            return booleanValue ? 'TRUE' : 'FALSE';
          }
        // Omit others:
        case null:
        default:
          if (configuration.stringEscapeMode == CsvStringEscapeModes.all) {
            // Escape string.
            return configuration.stringEscape.escape('');
          } else {
            // Do not escape string.
            return '';
          }
      }
    });

    try {
      // Write row.
      _sink.write(strings.join(configuration.fieldSeparator.delimiter) +
          configuration.newLine.newLine);

      // Update state.
      _firstRow = false;
    } catch (e) {
      throw CsvWriteException(
        writer: this,
        rowData: values,
        innerException: e,
      );
    }
  }

  /// Writes a first row with all [titles].
  ///
  /// Ensures that the titles are written only to the first row.
  /// Throws [CsvWriteException] if writing titles failed.
  void writeTitles(Iterable<String> titles) {
    // Ensure correct state.
    assert(!_wroteTitles, 'Titles are already written!');
    assert(
      _firstRow,
      'Values are already written. Adding a title is no more allowed!',
    );

    // Write the titles to the first row.
    _writeRow(titles);

    // Update state.
    _wroteTitles = true;
  }

  /// Writes a row of [values].
  ///
  /// If [configuration.withTitles] is true, [writeTitles] must be called first.
  /// Throws [CsvWriteException] if writing values failed.
  void writeValues(Iterable<dynamic> values) {
    // Ensure correct state.
    assert(
      !configuration.withTitles || _wroteTitles,
      'Titles are required, but no title was written. Write titles before writing values or set configuration.withTitles to false!',
    );

    // Update state.
    _writeRow(values);
  }

  /// Returns a [Future] that completes once all buffered data written.
  Future<void> flush() async {
    await _sink.flush();
  }
}
