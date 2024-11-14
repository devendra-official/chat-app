import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:messenger/core/error/error.dart';
import 'package:messenger/core/server/server.dart';
import 'package:messenger/features/authentication/model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  Authentication({required this.client, required this.preferences});

  final Client client;
  final SharedPreferences preferences;

  Future<Either<AuthModel, Failure>> signin(
      String email, String password) async {
    try {
      final result = await client.post(
        headers: {'Content-Type': "Application/json"},
        body: jsonEncode({"email": email, "password": password}),
        Uri.parse("$serverAddress/auth/login"),
      );
      if (result.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(result.body);
        await preferences.setString("token", data["token"]);
        return Left(AuthModel.fromJson(data));
      }
      return Right(Failure(jsonDecode(result.body)["message"]));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }
}
