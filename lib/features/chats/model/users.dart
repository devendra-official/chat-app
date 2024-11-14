import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:messenger/core/error/error.dart';
import 'package:messenger/core/models/messages_model.dart';
import 'package:messenger/core/models/users.dart';
import 'package:messenger/core/server/server.dart';
import 'package:messenger/init_dependency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class UsersRepo {
  UsersRepo(this.client, this.preferences);

  final Client client;
  final SharedPreferences preferences;

  Future<Either<UserModel, Failure>> getUsers() async {
    try {
      String? token = preferences.getString("token");
      if (token == null) {
        return Right(Failure("failed to request,Please login and try again"));
      }
      final result = await client.get(
        headers: {"Content-Type": "Application/json", "x-auth-token": token},
        Uri.parse("$serverAddress/get-users"),
      );
      io.Socket socket = serviceLocator<io.Socket>();
      if (result.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(result.body);
        socket.connect();
        socket.emitWithAck("initial", data["email"]);
        return Left(UserModel.fromJson(data["users"], data["email"]));
      }
      return Right(Failure(jsonDecode(result.body)["message"]));
    } catch (e) {
      return Right(Failure());
    }
  }

  Future<Either<MessagesModel, Failure>> getMessages() async {
    try {
      String? token = preferences.getString("token");
      if (token == null) {
        return Right(Failure("failed to request,Please login and try again"));
      }
      final result = await client.get(
        headers: {"Content-Type": "Application/json", "x-auth-token": token},
        Uri.parse("$serverAddress/get-messages"),
      );
      if (result.statusCode == 200) {
        List<dynamic> data = jsonDecode(result.body);
        return Left(
          MessagesModel.fromJson(data, ""),
        );
      }
      return Right(Failure(jsonDecode(result.body)["message"]));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }
}
