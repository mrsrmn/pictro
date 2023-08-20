import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pictro/utils/utils.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterValidateNumber>(_onRegisterValidateNumber);
  }

  void _onRegisterValidateNumber(RegisterValidateNumber event, Emitter emit) {
    emit(RegisterCheckingPhone());

    Utils.validatePhone(event.value, emit);
  }
}
