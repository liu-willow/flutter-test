
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:wallet_test/components/neffos/conn.dart';
import 'package:wallet_test/components/neffos/event.dart';
import 'package:wallet_test/components/neffos/message.dart';
import 'package:wallet_test/components/neffos/neffos.dart';
import 'package:wallet_test/components/neffos/ns_conn.dart';

import 'package:wallet_test/logger/logger.dart';

class Neffos {
  void init() async {
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.get('192.168.8.139', 15000, '/websocket');
    request.headers.add('Connection', 'upgrade');
    request.headers.add('Upgrade', 'websocket');
    request.headers.add('sec-websocket-version', '13');
    request.headers.add('sec-websocket-key', base64.encode(List<int>.generate(8, (_) => Random().nextInt(255))));
    request.headers.add('sync', "Q96MLCQjiSQT0kGUZBKA5r6k/Kb2a+IYkojzt9Zawo+fIjWD5PpkilOPdnwKttbOyf0OLsYiP9cYXkdA+ykPd5SZ6iuAXuGoSX3QJEf72Hs+ekrwhiJwT/vcRp8jq0IrZ+w3HXQeQDwJMjBnj/aI8Hq6mMlQ99ow548iIl9z229wOVgvxlVLB1J8zhFbG87ObSMH4NGCaDHWwIq9RTUyl/Duq+TU9L3SFO8dUc7Kt5z/zlE+jvoMmwR7r/k5c43fIOM7zsWMrBonK4DuGSG+Qj6Yy33Kn5u6H4nkAMZmLm0=");

    HttpClientResponse response = await request.close();
    Socket socket = await response.detachSocket();
    WebSocket ws = WebSocket.fromUpgradedSocket(
      socket,
      serverSide: false,
    );
    ws.listen((event) {
      print("--------------data-------------------");
      print(event);
    },
        onError: (e) {
          print("--------------error-------------------");
          print(e);
        },
        onDone: () => {}
    );
    ws.add("M");
  }

  void connect() async {
    try {
      Conn conn = await dial('ws://192.168.8.139:15000/websocket', {
        "137": {
          OnNamespaceConnect: (NsConn ns, Message msg) {
            loggerNoStack.d(<String, dynamic>{
              "event": "OnNamespaceConnect",
              "data": msg.toJson()
            });
          },
          OnNamespaceConnected: (NsConn ns, Message msg) {
            loggerNoStack.d(<String, dynamic>{
              "event": "OnNamespaceConnected",
              "data": msg.toJson()
            });
          },
          "0x937a42e7c244fa6c3d4b449299c4b6e5a7ee3c47": (NsConn ns, Message msg) {
            loggerNoStack.d(<String, dynamic>{
              "event": "---------------------------------------",
              "data": jsonDecode(msg.body!) as Map<String, dynamic>
            });
          }
        }
      },
          pingInterval: const Duration(seconds: 29),
          connectTimeout: const Duration(seconds: 3),
          headers: {
            'sync': 'Q96MLCQjiSQT0kGUZBKA5r6k/Kb2a+IYkojzt9Zawo+fIjWD5PpkilOPdnwKttbOyf0OLsYiP9cYXkdA+ykPd5SZ6iuAXuGoSX3QJEf72Hs+ekrwhiJwT/vcRp8jq0IrZ+w3HXQeQDwJMjBnj/aI8Hq6mMlQ99ow548iIl9z229wOVgvxlVLB1J8zhFbG87ObSMH4NGCaDHWwIq9RTUyl/Duq+TU9L3SFO8dUc7Kt5z/zlE+jvoMmwR7r/k5c43fIOM7zsWMrBonK4DuGSG+Qj6Yy33Kn5u6H4nkAMZmLm0=',
          }

      );
      // loggerNoStack.w(conn.id);
      NsConn nsConn = await conn.connect("137");
      loggerNoStack.w(nsConn.namespace);

    } catch(e) {
      loggerNoStack.e(e);
    }
  }
}