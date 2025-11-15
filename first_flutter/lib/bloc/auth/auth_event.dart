import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String? userName;

  LoginRequested(this.email, this.password, {this.userName});

  @override
  List<Object?> get props => [email, password, userName];
}

class LogoutRequested extends AuthEvent {}

class ClearError extends AuthEvent {}
