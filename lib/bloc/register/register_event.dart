part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterValidateNumber extends RegisterEvent {
  final String value;

  RegisterValidateNumber({required this.value});
}