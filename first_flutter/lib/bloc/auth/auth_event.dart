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

class RegisterRequested extends AuthEvent {
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String password;
  final String passwordConfirmation;

  RegisterRequested({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [nombre, apellido, email, telefono, password, passwordConfirmation];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResendConfirmationRequested extends AuthEvent {
  final String email;

  ResendConfirmationRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class LogoutRequested extends AuthEvent {}

class ClearError extends AuthEvent {}
