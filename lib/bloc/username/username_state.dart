part of 'username_bloc.dart';

@immutable
abstract class UsernameState {}

class UsernameInitial extends UsernameState {}

class UsernameLoading extends UsernameState {}

class UsernameSetError extends UsernameState {
  final String message;

  UsernameSetError({required this.message});
}

class UsernameSetSuccess extends UsernameState {}
