import 'dart:io';
import 'package:path/path.dart' show join, dirname;

Future<String> context(String file) async {
  File stream = File(join(dirname(Directory.current.path), 'flutter-test/assets/$file'));
  return await stream.readAsString();
}