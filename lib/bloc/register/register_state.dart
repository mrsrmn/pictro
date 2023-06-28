part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterCheckingPhone extends RegisterState {}

class RegisterPhoneEmpty extends RegisterState {}

class RegisterPhoneInvalid extends RegisterState {}

class RegisterPhoneValid extends RegisterState {}
