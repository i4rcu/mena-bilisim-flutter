part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final int userId;
  final String kullanici_vasfi;
  LoginSuccess({required this.userId,required this.kullanici_vasfi});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
