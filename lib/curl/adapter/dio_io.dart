import 'package:dio/dio.dart';
import 'package:dio/io.dart';

HttpClientAdapter createAdapter(String proxy) => IOHttpClientAdapter(
  onHttpClientCreate: (client) {
    client.findProxy = (uri) {
      return 'PROXY $proxy';
    };
    return client;
  },
  validateCertificate: (cert, host, port) {
    return true;
  },
);