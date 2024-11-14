import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessagesModel {
  late List<types.Message> messages;

  MessagesModel.fromJson(List<dynamic> json,String user) {
    messages = json.map((item) {
      return types.TextMessage(
        author: types.User(id: item["from"]),
        id: item["to"],
        text: item["message"],
      );
    }).toList();
  }
}
