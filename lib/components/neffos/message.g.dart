// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
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

Message _$MessageFromString(String data) {
  List arr = data.split(";");

  return Message(
      wait: arr[0],
      namespace: arr.length > 1 ? arr[1] : '',
      room: arr.length > 1 ? arr[2] : '',
      event: arr.length > 1 ? arr[3] : '',
      isError: arr.length > 1 ? arr[4] == "" : false,
      isNoOp: arr.length > 1 ? arr[5] == "" : false,
      body: arr.length > 1 ? arr[6] : ''
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'namespace': instance.namespace,
      'isLocal': instance.isLocal,
      'event': instance.event,
      'wait': instance.wait,
      'room': instance.room,
      'err': instance.err,
      'isError': instance.isError,
      'body': instance.body,
    };
