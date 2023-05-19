import 'package:wallet_test/logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'event.dart';
import 'message.dart';
import 'ns_conn.dart';
import 'error.dart';


typedef MessageHandlerFunc =  Function(NsConn ns, Message msg);
typedef WaitingMessageFunc = void Function(Message msg);

class Conn {
  bool? allowNativeMessages;

  final WebSocketChannel channel;
  late Map<String, NsConn> connectedNamespaces = <String, NsConn>{};
  late Map<String, Map<String, MessageHandlerFunc>> namespaces = <String, Map<String, MessageHandlerFunc>>{};
  late Map<String, WaitingMessageFunc> waitingMessages = <String, WaitingMessageFunc>{};
  late List<String> queue = <String>[];
  late Map<String, void Function()>? waitServerConnectNotifiers = <String, void Function()>{};

  bool? closed;
  String? id;
  int? reconnectTries;
  bool? _isAcknowledged;

  Conn(this.channel, this.namespaces,) {
    _isAcknowledged = false;
    reconnectTries = 0;
    closed = false;
    stream?.listen((data) => _onMessage(data), onError: _onError, onDone: _onDone);
  }

  Future<NsConn> connect(String namespace) async {
    return askConnect(namespace);
  }

  Future<Message> ask(Message msg) async {
    return Future<Message>(() {
      if (isClosed!) {
        return Future.error(errorClosed);
      }
      msg.wait = getWait();
      messageH(Message receive) {
        loggerNoStack.w("messageH: $receive");
        if (receive.isError!) {
          return Future.error(receive.err!);
        }
        return Future.value(receive);
      }

      waitingMessages[msg.wait!] = messageH;

      if (!write(msg)) {
        return Future.error(errWrite);
      }

      return Future.value(msg);
    });
  }

  Future<NsConn> askConnect(String namespace) async {
    NsConn? nsConn = this.namespace(namespace);

    if (nsConn != null) {
      return nsConn;
    }

    Map<String, MessageHandlerFunc>? events = getEvents(namespaces, namespace);

    if (events == null) {
      return Future.error(errBadNamespace);
    }

    Message connectMessage = Message(namespace: namespace, isLocal: true, event: OnNamespaceConnect);
    NsConn ns = NsConn(conn: this, namespace: namespace, events: events);
    SocketError? err = fireEvent(ns, connectMessage);
    if (err != null) {
      return Future.error(err);
    }

    try {
      await ask(connectMessage);
    } catch (err) {
      return Future.error(err);
    }

    connectedNamespaces[namespace] = ns;
    connectMessage.event = OnNamespaceConnected;
    fireEvent(ns, connectMessage);

    return ns;
  }

  Future<SocketError> askDisconnect(Message msg) async {
    // TODO: implement askDisconnect
    throw UnimplementedError();
  }

  void close() {
    if (closed!) return;
    Message disconnectMsg = Message(
      event: OnNamespaceDisconnect,
      isForced: true,
      isLocal: true,
    );

    connectedNamespaces.forEach((_, NsConn ns) {
      ns.forceLeaveAll(true);
      disconnectMsg.namespace = ns.namespace;
      fireEvent(ns, disconnectMsg);
      connectedNamespaces.remove(ns.namespace);
    });
    waitingMessages.clear();
    closed = true;
    sink?.close();
  }

  bool? get isAcknowledged => _isAcknowledged;
  bool? get isClosed => closed;
  NsConn? namespace(String namespace) {
    return connectedNamespaces[namespace];
  }

  Future<NsConn> waitServerConnect(String namespace) {
    // TODO: implement waitServerConnect
    throw UnimplementedError();
  }

  bool get wasReconnected => reconnectTries! > 0;
  WebSocketSink? get sink => channel.sink;
  Stream? get stream => channel.stream;

  bool write(Message msg) {
    if (msg.isConnect && !msg.isDisconnect) {
      if (!namespaces.containsKey(msg.namespace)) return false;

      if (msg.room == "" && !msg.isRoomJoin && !msg.isRoomLeft) {
        // if(!ns.rooms[msg.room])
      }
    }

    String data = serializeMessage(msg);
    return _write(data);
  }

  void writeEmptyReply(String wait) {
    // TODO: implement writeEmptyReply
  }

  Future<void> _onMessage(String msg) async {
    Message toMessage = Message.fromString(msg);
    if (toMessage.event == OnNamespaceConnect) {
      id = msg;
      return;
    }

    if(toMessage.namespace != "" && toMessage.event != "") {
      if (connectedNamespaces.containsKey(toMessage.namespace)) {
        NsConn? nsConn = connectedNamespaces[toMessage.namespace];
        SocketError? err = fireEvent(nsConn!, toMessage);
        if (err != null) {
          return Future.error(err);
        }
      }
    }
    loggerNoStack.w("-------------------------------------------------------------");
    loggerNoStack.w(msg);
  }

  Future<void> _onError(err) async {
    close();
  }

  Future<void> _onDone() async {
    if (!isClosed!) {
      close();
    }
  }

  bool _write(dynamic data) {
    try {
      if (isClosed!) return false;
      sink?.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}

SocketError? fireEvent(NsConn ns, Message msg) {
  if (ns.events![msg.event] != null) {
    return ns.events![msg.event]!(ns, msg);
  }

  if (ns.events![OnAnyEvent] != null) {
    return ns.events![OnAnyEvent]!(ns, msg);
  }

  return null;
}

String serializeMessage(Message msg) => msg.toString();

String getWait() {
  Stopwatch s = Stopwatch()..start();

  return waitComesFromClientPrefix + s.elapsedMicroseconds.toString();
}

Map<String, MessageHandlerFunc>? getEvents(Map<String, Map<String, MessageHandlerFunc>> namespaces, String namespace,) {
  return namespaces[namespace];
}
