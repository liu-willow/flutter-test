import 'package:json_annotation/json_annotation.dart';
import 'event.dart';
part 'message.g.dart';

@JsonSerializable()
class Message {
  final String _split = ';';
  String? body;
  String? err;
  String? event;

  @JsonKey(nullable: true)
  bool? isError;

  bool? isForced;
  bool? isInvalid;
  bool? isLocal;
  bool? isNative;
  bool? isNoOp;
  String? namespace;
  String? room;
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

  T unmarshal<T>() {
    // TODO: implement unmarshal
    throw UnimplementedError();
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
    this.room,
    this.setBinary,
    this.wait,
  });

  /// Create a new instance from a json
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  factory Message.fromString(String data) => _$MessageFromString(data);
  /// Serialize to json
  Map<String, dynamic> toJson() => _$MessageToJson(this);

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
      body: body ?? this.body,
      err: err ?? this.err,
      event: event ?? this.event,
      isError: isError ?? this.isError,
      isForced: isForced ?? this.isForced,
      isInvalid: isInvalid ?? this.isInvalid,
      isLocal: isLocal ?? false,
      isNative: isNative ?? this.isNative,
      isNoOp: isNoOp ?? this.isNoOp,
      namespace: namespace ?? this.namespace,
      room: room ?? this.room,
      setBinary: setBinary ?? this.setBinary,
      wait: wait ?? this.wait,
    );
  }
}