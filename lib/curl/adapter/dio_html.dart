import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

HttpClientAdapter createAdapter(String proxy) => BrowserHttpClientAdapter();