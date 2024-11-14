import 'dart:async';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:messenger/core/server/server.dart';
import 'package:messenger/features/authentication/model/auth.dart';
import 'package:messenger/features/chats/model/socket.dart';
import 'package:messenger/features/chats/model/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> dependency() async {
  io.Socket socket = io.io(
    serverAddress,
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
  );
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Client client = http.Client();
  StreamController<bool> authStream = StreamController<bool>();
  StreamController<types.Message> messagesStream =
      StreamController<types.Message>.broadcast();

  if (preferences.getString("token") != null) {
    authStream.add(true);
  }
  serviceLocator.registerSingleton<StreamController<types.Message>>(messagesStream);
  serviceLocator.registerSingleton<io.Socket>(socket);
  serviceLocator.registerFactory<SharedPreferences>(() => preferences);
  serviceLocator.registerFactory<Client>(() => client);
  serviceLocator.registerSingleton<StreamController<bool>>(authStream);
  serviceLocator.registerLazySingleton<Authentication>(
      () => Authentication(client: client, preferences: preferences));
  serviceLocator
      .registerLazySingleton<UsersRepo>(() => UsersRepo(client, preferences));

  socket.on('receiveMessage', (data) {
    receiveMessage(data);
  });
}