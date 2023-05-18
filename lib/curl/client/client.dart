import 'package:http/http.dart';
import 'client_stub.dart'
if (dart.library.io) 'client_io.dart'
if (dart.library.html) 'client_html.dart';

Client init(String proxy) => newClient(proxy);