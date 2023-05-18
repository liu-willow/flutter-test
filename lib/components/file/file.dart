import 'stub.dart'
if (dart.library.io) 'io.dart'
if (dart.library.html) 'html.dart';

Future<String> file_get_content(String file) async {
  return await context(file);
}