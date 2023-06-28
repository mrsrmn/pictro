import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scribble/utils/database.dart';

part 'username_event.dart';
part 'username_state.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  final Database database = Database();

  UsernameBloc() : super(UsernameInitial()) {
    on<SetUsernameOfUser>(setUsernameOfUser);
  }

  void setUsernameOfUser(SetUsernameOfUser event, Emitter emit) async {
    emit(UsernameLoading());

    await database.set(event.number, event.username);

    emit(UsernameSetSuccess());
  }
}
