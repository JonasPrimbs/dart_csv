# dart_csv

A Dart package to write comma separated values to a file.

## Features

- Write CSV files

## Getting started

In your flutter/dart project add the dependency:
```yaml
dependencies:
  ...
  dart_csv:
```

## Usage

Import package:
```dart
import 'package:dart_csv/dart_csv.dart';
```

Create configuration and writer:
```dart
// Create predefined configuration compliant with RFC 7111:
final configuration = CsvConfiguration.rfc7111();
// Create file:
final file = File('./test.csv');
// Create writer from file's IOSink:
final writer = CsvWriter(file.openWrite());
```

Write to file:
```dart
// Write titles:
writer.writeTitles(['id', 'product', 'price']);
// Write values:
writer.writeValues([1, 'Apple Juice', 3.49]);
// Wait for buffer to be written.
await writer.flush();

// Don't forget to close the sink!
await ioSink.close();
```
