import 'package:flutter/services.dart';

Future<String> context(String file) async {
  return await rootBundle.loadString(file);
}