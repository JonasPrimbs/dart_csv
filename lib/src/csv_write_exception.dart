import './csv_writer.dart';

final class CsvWriteException implements Exception {
  /// The writer which failed to write.
  final CsvWriter writer;

  /// The data which failed to write.
  final Iterable<dynamic> rowData;

  /// The inner exception
  final dynamic innerException;

  const CsvWriteException({
    required this.writer,
    required this.rowData,
    this.innerException,
  });

  @override
  String toString() {
    return 'Failed to write row to CSV file${innerException == null ? '!' : ': ${innerException.toString()}'}';
  }
}
