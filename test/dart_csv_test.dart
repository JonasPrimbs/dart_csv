import 'dart:io';

import 'package:dart_csv/dart_csv.dart';
import 'package:test/test.dart';

void main() {
  group('RFC 7111', () async {
    final configuration = CsvConfiguration.rfc7111(
      withTitles: true,
      escapeMacros: true,
    );

    (File file, IOSink sink, CsvWriter writer) createFile(String fileName) {
      final file = File(fileName);
      final ioSink = file.openWrite(
        mode: FileMode.writeOnlyAppend,
        encoding: configuration.encoding,
      );
      final writer = CsvWriter(ioSink);
      return (file, ioSink, writer);
    }
    Future<List<String>> closeAndCheckFile(File file, IOSink sink) async {
      await sink.close();
      return await file.readAsLines();
    }

    test('Simple file', () async {
      final (file, sink, writer) = createFile('./temp/test_rfc7111.csv');

      // Check initial state.
      expect(writer.hasTitle, isFalse);

      // Write titles and check state.
      writer.writeTitles(['int', 'string', 'double', 'boolean']);
      expect(writer.hasTitle, isTrue);
      await writer.flush();
      expect(writer.hasTitle, isTrue);

      // Write values.
      writer.writeValues([1, 'string 1', 1.2, false]);
      writer.writeValues([2, 'string 2', 2.3, true]);
      await writer.flush();

      // End writing and read file.
      final lines = await closeAndCheckFile(file, sink);
      expect(lines, equals([
        'int,string,double,boolean',
        '1,"string 1",1.2,0',
        '2,"string 2",2.3,1',
      ]));

      await file.delete();
    });
  });
}
