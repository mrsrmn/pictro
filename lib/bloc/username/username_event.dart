part of 'username_bloc.dart';

@immutable
abstract class UsernameEvent {}

class SetUsernameOfUser extends UsernameEvent {
  final String username;

  SetUsernameOfUser({
    required this.username
  });
}
