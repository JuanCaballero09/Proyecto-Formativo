import 'package:flutter/foundation.dart';

/// Base state class for all BLoCs
abstract class BaseState {
  const BaseState();
}

/// State representing the initial state
class InitialState extends BaseState {
  const InitialState();
}

/// State representing a loading state
class LoadingState extends BaseState {
  final String? message;
  
  const LoadingState({this.message});
}

/// State representing an error state
class ErrorState extends BaseState {
  final String message;
  final String? code;
  final VoidCallback? onRetry;
  
  const ErrorState({
    required this.message,
    this.code,
    this.onRetry,
  });
}

/// State representing a success state with data
class SuccessState<T> extends BaseState {
  final T data;
  
  const SuccessState(this.data);
}
