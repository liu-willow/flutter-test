import 'conn.dart';
import 'event.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'web_socket_channel_stub.dart'
if (dart.library.html) 'web_socket_channel_html.dart'
if (dart.library.io) 'web_socket_channel_io.dart';

Future<Conn> dial(
    String url,
    Map<String, Map<String, MessageHandlerFunc>> connHandler,
    {
      Iterable<String>? protocols,
      Map<String, dynamic>? headers,
      Duration? pingInterval,
      Duration? connectTimeout
    }
    ) async {

  WebSocketChannel channel = connectWebSocket(url, protocols: protocols, pingInterval: pingInterval, connectTimeout: connectTimeout, headers: headers);
  channel.sink.add(ackBinary);
  return Conn(channel, connHandler);
}