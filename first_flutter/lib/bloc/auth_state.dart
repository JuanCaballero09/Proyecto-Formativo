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

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}
