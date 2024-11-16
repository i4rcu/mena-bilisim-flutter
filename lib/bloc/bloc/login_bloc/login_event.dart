part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginSubmitted({required this.username, required this.password});
}
