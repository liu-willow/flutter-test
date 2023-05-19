import 'dart:convert';

import 'event.dart';

class Message {
  final String _split = ';';
  String? body;
  String? err;
  String? event;
  bool? isError;
  bool? isForced;
  bool? isInvalid;
  bool? isLocal;
  bool? isNative;
  bool? isNoOp;
  String? namespace;
  String? room = '';
  bool? setBinary;
  String? wait;
  bool get isConnect => event == OnNamespaceConnect;
  bool get isDisconnect => event == OnNamespaceDisconnect;
  bool get isRoomJoin => event == OnRoomJoin;
  bool get isRoomLeft => event == OnRoomLeft;
  bool get isWait {
    if (wait!.isEmpty) return false;
    if (wait!.startsWith(waitIsConfirmationPrefix)) return true;

    return wait!.startsWith(waitComesFromClientPrefix);
  }

  Map<String, dynamic> unmarshal<T>() {
    Map<String, dynamic> JSON = toJson();
    dynamic body = jsonDecode(JSON['body']);
    JSON['body'] = body;
    return JSON;
  }

  Message({
    this.body,
    this.err,
    this.event,
    this.isError,
    this.isForced,
    this.isInvalid,
    this.isLocal,
    this.isNative,
    this.isNoOp,
    this.namespace,
    this.room = '',
    this.setBinary,
    this.wait,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      namespace: json['namespace'] as String,
      isLocal: json['isLocal'] as bool,
      event: json['event'] as String,
      wait: json['wait'] as String,
      room: json['room'] as String,
      err: json['err'] as String,
      isError: json['isError'] as bool,
      body: json['body'] as String,
    );
  }

  factory Message.fromString(String data) {
    List arr = data.split(";");

    return Message(
        wait: arr[0],
        isLocal: false,
        isNative: false,
        namespace: arr.length > 1 ? arr[1] : '',
        room: arr.length > 1 ? arr[2] : '',
        event: arr.length > 1 ? arr[3] : OnNamespaceConnect,
        isError: arr.length > 1 ? arr[4] == "" : false,
        isNoOp: arr.length > 1 ? arr[5] == "" : false,
        body: arr.length > 1 ? arr[6] : ''
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'namespace': namespace,
      'isLocal': isLocal,
      'event': event,
      'wait': wait,
      'room': room,
      'err': err,
      'isError': isError,
      'body': body,
    };
  }

  @override
  String toString() {
    return <dynamic>[wait, namespace, room, event, isError , isNoOp, body].join(_split);
  }

  Message copyWith({
    required String body,
    required String err,
    required String event,
    required bool isError,
    required bool isForced,
    required bool isInvalid,
    required bool isLocal,
    required bool isNative,
    required bool isNoOp,
    required String namespace,
    required String room,
    required bool setBinary,
    required String wait,
  }) {
    return Message(
      body: body,
      err: err,
      event: event,
      isError: isError,
      isForced: isForced,
      isInvalid: isInvalid,
      isLocal: isLocal,
      isNative: isNative,
      isNoOp: isNoOp,
      namespace: namespace,
      room: room,
      setBinary: setBinary,
      wait: wait,
    );
  }
}