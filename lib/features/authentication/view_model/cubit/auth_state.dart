part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSucces extends AuthState {
  final AuthModel model;

  AuthSucces(this.model);
}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure([this.message = 'something went wrong']);
}
