import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:messenger/core/error/error.dart';
import 'package:messenger/core/models/users.dart';
import 'package:messenger/features/chats/model/users.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this.users) : super(UsersLoading());

  final UsersRepo users;

  Future<void> getUsers() async {
    try {
      emit(UsersLoading());
      Either<UserModel, Failure> result = await users.getUsers();
      result.fold((usermodel) {
        return emit(UsersSuccess(usermodel));
      }, (failure) {
        return emit(UsersFailed(failure.message));
      });
    } catch (e) {
      return emit(UsersFailed());
    }
  }
}

@immutable
sealed class UsersState {}

final class UsersLoading extends UsersState {}

final class UsersFailed extends UsersState {
  final String failure;
  UsersFailed([this.failure = "something went wrong"]);
}

final class UsersSuccess extends UsersState {
  final UserModel userModel;

  UsersSuccess(this.userModel);
}
