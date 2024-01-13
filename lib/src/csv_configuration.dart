import 'dart:convert';

import 'package:intl/intl.dart';

import './csv_field_separators.dart';
import './csv_new_line_types.dart';
import './csv_string_escape.dart';
import './csv_string_escape_modes.dart';

final class CsvConfiguration {
  /// Whether the file should contain a title line.
  final bool withTitles;

  /// The field separator which delimits columns.
  final CsvFieldSeparators fieldSeparator;

  /// The new line separator which delimits rows.
  final CsvNewLineTypes newLine;

  /// The string escape character which escapes string fields.
  final CsvStringEscape stringEscape;

  /// Specifies when fields are string escaped.
  final CsvStringEscapeModes stringEscapeMode;

  /// Whether Excel macros and formulas should be escaped to prevent CSV injection attacks.
  final bool escapeMacros;

  /// A whitelist of allowed characters as regular expression.
  final RegExp? allowedCharacters;

  /// A blacklist of disallowed characters as regular expression.
  final RegExp? disallowedCharacters;

  /// The number format.
  final NumberFormat numberFormat;

  /// The character encoding of the CSV file.
  final Encoding encoding;

  /// A CSV configuration compliant with RFC 4180 (CSV file with ASCII encoding).
  ///
  /// It can be exported [withTitles] which defaults to true.
  /// The [stringEscapeMode] defaults to [CsvStringEscapeModes.whenRequired].
  /// The [escapeMacros] parameter defaults to true to prevent CSV injections.
  /// If [allowedCharacters] is set, non-matching characters in string fields will be omitted.
  /// If [disallowedCharacters] is set, matching characters in string fields will be omitted.
  ///
  /// According to RFC 4180, the [encoding] defaults to ASCII.
  /// Make sure to change this when using non-US special characters!
  factory CsvConfiguration.rfc4180({
    bool withTitles = true,
    CsvStringEscapeModes stringEscapeMode = CsvStringEscapeModes.whenRequired,
    bool escapeMacros = true,
    RegExp? allowedCharacters,
    RegExp? disallowedCharacters,
    Encoding encoding = ascii,
  }) =>
      CsvConfiguration._(
        withTitles: withTitles,
        fieldSeparator: CsvFieldSeparators.comma,
        newLine: CsvNewLineTypes.crlf,
        stringEscape: CsvStringEscape.doubleQuote,
        stringEscapeMode: stringEscapeMode,
        escapeMacros: escapeMacros,
        allowedCharacters: allowedCharacters,
        disallowedCharacters: disallowedCharacters,
        numberFormat: NumberFormat('#0.#', 'en_US'),
        encoding: encoding,
      );

  /// A CSV configuration compliant with RFC 7111 (CSV file with UTF-8 encoding).
  ///
  /// It can be exported [withTitles] which defaults to true.
  /// The [stringEscapeMode] defaults to [CsvStringEscapeModes.whenRequired].
  /// The [escapeMacros] parameter defaults to true to prevent CSV injections.
  /// If [allowedCharacters] is set, non-matching characters in string fields will be omitted.
  /// If [disallowedCharacters] is set, matching characters in string fields will be omitted.
  ///
  /// According to RFC 7111, the [encoding] defaults to UTF-8.
  factory CsvConfiguration.rfc7111({
    bool withTitles = true,
    CsvStringEscapeModes stringEscapeMode = CsvStringEscapeModes.whenRequired,
    bool escapeMacros = true,
    RegExp? allowedCharacters,
    RegExp? disallowedCharacters,
    Encoding encoding = utf8,
  }) =>
      CsvConfiguration._(
        withTitles: withTitles,
        fieldSeparator: CsvFieldSeparators.comma,
        newLine: CsvNewLineTypes.crlf,
        stringEscape: CsvStringEscape.doubleQuote,
        stringEscapeMode: stringEscapeMode,
        escapeMacros: escapeMacros,
        allowedCharacters: allowedCharacters,
        disallowedCharacters: disallowedCharacters,
        numberFormat: NumberFormat('#0.#', 'en_US'),
        encoding: encoding,
      );

  /// A TSV (tab-separated values) configuration.
  ///
  /// It can be exported [withTitles] which defaults to true.
  /// The [stringEscapeMode] defaults to [CsvStringEscapeModes.whenRequired].
  /// The [escapeMacros] parameter defaults to true to prevent CSV injections.
  /// If [allowedCharacters] is set, non-matching characters in string fields will be omitted.
  /// If [disallowedCharacters] is set, matching characters in string fields will be omitted.
  /// The [numberFormat] defaults to US standard.
  /// The [encoding] defaults to UTF-8.
  factory CsvConfiguration.tsv(
    String path, {
    bool withTitles = true,
    CsvStringEscapeModes stringEscapeMode = CsvStringEscapeModes.whenRequired,
    bool escapeMacros = true,
    RegExp? allowedCharacters,
    RegExp? disallowedCharacters,
    NumberFormat? numberFormat,
    Encoding? encoding,
  }) =>
      CsvConfiguration._(
        withTitles: withTitles,
        fieldSeparator: CsvFieldSeparators.tab,
        newLine: CsvNewLineTypes.crlf,
        stringEscape: CsvStringEscape.doubleQuote,
        stringEscapeMode: stringEscapeMode,
        escapeMacros: escapeMacros,
        allowedCharacters: allowedCharacters,
        disallowedCharacters: disallowedCharacters == null
            ? RegExp(r'\t')
            : RegExp('\t|${disallowedCharacters.pattern}'),
        numberFormat: numberFormat ?? NumberFormat('#0.#', 'en_US'),
        encoding: encoding ?? utf8,
      );

  /// A custom CSV configuration.
  ///
  /// It can be exported [withTitles] which defaults to true.
  /// The [fieldSeparator] defaults to comma (,).
  /// The [newLine] defaults to CRLF (Windows standard).
  /// The [stringEscape] defaults to double quotes (").
  /// The [stringEscapeMode] defaults to [CsvStringEscapeModes.whenRequired].
  /// The [escapeMacros] parameter defaults to true to prevent CSV injections.
  /// If [allowedCharacters] is set, non-matching characters in string fields will be omitted.
  /// If [disallowedCharacters] is set, matching characters in string fields will be omitted.
  /// The [numberFormat] defaults to US standard.
  /// The [encoding] defaults to UTF-8.
  factory CsvConfiguration.custom({
    bool withTitles = true,
    CsvFieldSeparators fieldSeparator = CsvFieldSeparators.comma,
    CsvNewLineTypes newLine = CsvNewLineTypes.crlf,
    CsvStringEscape stringEscape = CsvStringEscape.doubleQuote,
    CsvStringEscapeModes stringEscapeMode = CsvStringEscapeModes.whenRequired,
    bool escapeMacros = true,
    RegExp? allowedCharacters,
    RegExp? disallowedCharacters,
    NumberFormat? numberFormat,
    Encoding? encoding,
  }) =>
      CsvConfiguration._(
        withTitles: withTitles,
        fieldSeparator: fieldSeparator,
        newLine: newLine,
        stringEscape: stringEscape,
        stringEscapeMode: stringEscapeMode,
        escapeMacros: escapeMacros,
        allowedCharacters: allowedCharacters,
        disallowedCharacters: disallowedCharacters == null
            ? RegExp(r'\t')
            : RegExp('\t|${disallowedCharacters.pattern}'),
        numberFormat: numberFormat ?? NumberFormat('#0.#', 'en_US'),
        encoding: encoding ?? utf8,
      );

  const CsvConfiguration._({
    this.withTitles = true,
    this.fieldSeparator = CsvFieldSeparators.comma,
    this.newLine = CsvNewLineTypes.crlf,
    this.stringEscape = CsvStringEscape.doubleQuote,
    this.stringEscapeMode = CsvStringEscapeModes.whenRequired,
    this.escapeMacros = true,
    this.allowedCharacters,
    this.disallowedCharacters,
    required this.numberFormat,
    this.encoding = utf8,
  });
}
