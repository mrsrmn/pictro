import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'username_event.dart';
part 'username_state.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  UsernameBloc() : super(UsernameInitial()) {
    on<SetUsernameOfUser>(setUsernameOfUser);
  }

  void setUsernameOfUser(SetUsernameOfUser event, Emitter emit) async {
    emit(UsernameLoading());

    if (event.username.isEmpty) {
      emit(UsernameSetError(message: "Please type something in!"));
      return;
    }

    await FirebaseAuth.instance.currentUser!.updateDisplayName(event.username);

    emit(UsernameSetSuccess());
  }
}
