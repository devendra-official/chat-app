import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:messenger/core/error/error.dart';
import 'package:messenger/core/models/messages_model.dart';
import 'package:messenger/features/chats/model/users.dart';

class MessagesCubit extends Cubit<MessageState> {
  MessagesCubit(this.users) : super(MessageLoading());

  final UsersRepo users;

  Future<void> getMessages() async {
    try {
      Either<MessagesModel, Failure> result = await users.getMessages();
      result.fold((messagesModel) {
        return emit(MessageSuccess(messagesModel));
      }, (failure) {
        return emit(MessageFailure(failure.message));
      });
    } catch (e) {
      return emit(MessageFailure(e.toString()));
    }
  }
}

@immutable
sealed class MessageState {}

final class MessageLoading extends MessageState {}

final class MessageFailure extends MessageState {
  final String failure;
  MessageFailure([this.failure = "something went wrong"]);
}

final class MessageSuccess extends MessageState {
  final MessagesModel messagesModel;

  MessageSuccess(this.messagesModel);
}
