part of 'username_bloc.dart';

@immutable
abstract class UsernameEvent {}

class SetUsernameOfUser extends UsernameEvent {
  final String number;
  final String username;

  SetUsernameOfUser({
    required this.number,
    required this.username
  });
}
