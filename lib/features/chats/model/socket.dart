import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:messenger/core/utils/utils.dart';
import 'package:messenger/init_dependency.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

io.Socket socket = serviceLocator<io.Socket>();

void sendMessage(BuildContext context, String message, String from, String to) {
  try {
    serviceLocator<StreamController<types.Message>>().add(
      types.TextMessage(
        author: User(id: from),
        id: to,
        text: message,
      ),
    );
    socket.emitWithAck(
        'sendMessage', {"message": message, "from": from, "to": to});
    socket.on('error', (error) {
      showMessage(error, context);
    });
  } catch (e) {
    showMessage(e.toString(), context);
  }
}

void receiveMessage(Map<String, dynamic> data) {
  serviceLocator<StreamController<types.Message>>().add(
    types.TextMessage(
      author: User(id: data['to']),
      id: data['from'],
      text: data['message'],
    ),
  );
}

// void userStatus(String msg) {}
