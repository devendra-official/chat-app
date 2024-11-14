import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:messenger/core/models/users.dart';
import 'package:messenger/core/themes/colors.dart';
import 'package:messenger/core/utils/utils.dart';
import 'package:messenger/features/chats/view/pages/chat.dart';
import 'package:messenger/features/chats/view_model/cubit/messages_cubit.dart';
import 'package:messenger/features/chats/view_model/cubit/users_cubit.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    List<types.Message> messages = [];
    return BlocListener<MessagesCubit, MessageState>(
      listener: (context, state) {
        if (state is MessageSuccess) {
          messages = state.messagesModel.messages.reversed.toList();
        }
        if (state is MessageFailure) {
          showMessage(state.failure, context);
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: 44,
            width: double.infinity,
            decoration: BoxDecoration(
              color: lightBlack,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Search",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: greyTextColor),
              ),
            ),
          ),
          BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (state is UsersFailed) {
                return Center(
                  child: Text(state.failure),
                );
              }
              if (state is UsersSuccess) {
                List<Users> users = state.userModel.users;
                return Column(
                  children: List.generate(users.length, (index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ChatPage(
                            user: users[index],
                            sender: state.userModel.owner,
                            messagelist: messages,
                          );
                        }));
                      },
                      leading: CircleAvatar(
                        backgroundColor: transparent,
                        child: CachedNetworkImage(
                          imageUrl: users[index].profile,
                          fit: BoxFit.fill,
                        ),
                      ),
                      title: Text(users[index].username),
                      subtitle: Text(users[index].email),
                    );
                  }),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
