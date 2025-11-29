import 'package:equatable/equatable.dart';

// Modelo de usuario simple
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  AuthError(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class RegistrationSuccess extends AuthState {
  final String message;

  RegistrationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetEmailSent extends AuthState {
  final String message;

  PasswordResetEmailSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ConfirmationEmailSent extends AuthState {
  final String message;

  ConfirmationEmailSent(this.message);

  @override
  List<Object?> get props => [message];
}
