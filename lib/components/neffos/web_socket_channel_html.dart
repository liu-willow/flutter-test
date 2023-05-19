import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Html version of websocket implementation
/// Used in Flutter web version
WebSocketChannel connectWebSocket(String url,
    {
      Iterable<String>? protocols,
      Map<String, dynamic>? headers,
      Duration? pingInterval,
      Duration? connectTimeout
    }) {
  List<String> query = <String>[];
  headers?.forEach((key, value) {
    query.add("$key=$value");
  });
  if (query.isNotEmpty) {
    String queryString = query.join("&");
    url = "$url?$queryString";
  }
  return HtmlWebSocketChannel.connect(url, protocols: protocols);
}
