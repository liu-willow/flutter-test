import 'package:dio/dio.dart';
import 'dio_stub.dart'
if (dart.library.io) 'dio_io.dart'
if (dart.library.html) 'dio_html.dart';

HttpClientAdapter init(String proxy) => createAdapter(proxy);