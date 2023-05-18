import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// IO version of websocket implementation
/// Used in Flutter mobile version
WebSocketChannel connectWebSocket(String url,
    {
      Iterable<String>? protocols,
      Map<String, dynamic>? headers,
      Duration? pingInterval,
      Duration? connectTimeout
    }) => IOWebSocketChannel.connect(url, protocols: protocols, pingInterval: pingInterval, connectTimeout: connectTimeout, headers: headers);
