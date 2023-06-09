import 'dart:async';

import 'conn.dart';
import 'message.dart';
import 'room.dart';

class NsConn {
  Conn? conn;
  Map<String, MessageHandlerFunc>? events;
  String? namespace;
  Map<String, Room>? rooms;

  NsConn({
    this.conn,
    this.events,
    this.namespace,
    this.rooms,
  });

  void ask(String event, body, WaitingMessageFunc callback) async {
    String wait = genWait();
    conn?.waitingMessages[wait] = callback;
    conn?.ask(Message(wait: wait, namespace: namespace, event: event, body: body));
  }

  Future<Room> askRoomJoin(String roomName) {
    // TODO: implement askRoomJoin
    throw UnimplementedError();
  }

  Future<String> askRoomLeave(Message msg) {
    // TODO: implement askRoomLeave
    throw UnimplementedError();
  }

  Future<String> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  bool emit(String event, String body) {
    // TODO: implement emit
    throw UnimplementedError();
  }

  bool emitBinary(String event, String body) {
    // TODO: implement emitBinary
    throw UnimplementedError();
  }

  void forceLeaveAll(bool isLocal) {
    // TODO: implement forceLeaveAll
  }

  Future<Room> joinRoom(String roomName) async {
    // TODO: implement joinRoom
    throw UnimplementedError();
  }

  Future<String> leaveAll() {
    // TODO: implement leaveAll
    throw UnimplementedError();
  }

  void replyRoomJoin(Message msg) {
    // TODO: implement replyRoomJoin
  }

  void replyRoomLeave(Message msg) {
    // TODO: implement replyRoomLeave
  }

  Room room(String roomName) {
    // TODO: implement room
    throw UnimplementedError();
  }
}