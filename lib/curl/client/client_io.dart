import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

Client newClient(String proxy) => IOClient(HttpClient()..findProxy = (uri) {
  return 'PROXY $proxy; DIRECT';
}..badCertificateCallback = (X509Certificate cert, String host, int port) { return false;});