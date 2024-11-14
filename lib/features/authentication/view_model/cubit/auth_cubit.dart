import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:messenger/core/error/error.dart';
import 'package:messenger/features/authentication/model/auth.dart';
import 'package:messenger/features/authentication/model/auth_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authentication) : super(AuthLoading());

  final Authentication authentication;

  void signin(String email, String password) async {
    try {
      Either<AuthModel, Failure> res =
          await authentication.signin(email, password);
      res.fold((model) {
        emit(AuthSucces(model));
      }, (failure) {
        emit(AuthFailure(failure.message));
      });
    } catch (e) {
      emit(AuthFailure());
    }
  }
}
