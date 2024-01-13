import 'dart:io';

import 'package:dart_csv/dart_csv.dart';

Future<void> main() async {
  // Create configuration.
  final configuration = CsvConfiguration.rfc7111(
    withTitles: true, // Whether titles are required.
    escapeMacros: true, // Prevents CSV injection by appending a space before formulae.
  );

  // Create a new file and wrap a CSV writer around.
  final file = File('./test.csv');
  final ioSink = file.openWrite(
    mode: FileMode.writeOnlyAppend,
    encoding: configuration.encoding,
  );
  final writer = CsvWriter(ioSink);

  // Write titles.
  writer.writeTitles([
    'id',
    'product',
    'price',
  ]);
  await writer.flush(); // Use this to ensure that buffered write operations are finished.

  // Write values.
  writer.writeValues([
    1,
    'Apple Juice',
    3.49,
  ]);
  writer.writeValues([
    1,
    'Banana Juice',
    3.99,
  ]);
  await writer.flush(); // This can also be done after multiple write operations.

  // Don't forget to close the writer when finished!
  await ioSink.close();
}
