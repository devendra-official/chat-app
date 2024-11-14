import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:messenger/core/models/users.dart';
import 'package:messenger/core/themes/colors.dart';
import 'package:messenger/features/chats/model/socket.dart';
import 'package:messenger/init_dependency.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    required this.user,
    required this.sender,
    required this.messagelist,
  });

  final Users user;
  final String sender;
  final List<types.Message> messagelist;

  @override
  Widget build(BuildContext context) {
    List<types.Message> messagels = [];
    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: transparent,
                child: CachedNetworkImage(
                  imageUrl: user.profile,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    user.phone,
                    style: const TextStyle(color: greyTextColor),
                  )
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone))
        ],
      ),
      body: StreamBuilder<types.Message>(
        stream: serviceLocator<StreamController<types.Message>>().stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            messagels.insert(0, snapshot.data!);
          }
          return Chat(
            messages: messagelist,
            onSendPressed: (message) {
              sendMessage(context, message.text, sender, user.email);
            },
            user: User(id: sender),
          );
        },
      ),
    );
  }
}
