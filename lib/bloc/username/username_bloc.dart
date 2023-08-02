import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

part 'username_event.dart';
part 'username_state.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  UsernameBloc() : super(UsernameInitial()) {
    on<SetUsernameOfUser>(setUsernameOfUser);
  }

  void setUsernameOfUser(SetUsernameOfUser event, Emitter emit) async {
    final userRef = FirebaseFirestore.instance.collection("users").doc(
      FirebaseAuth.instance.currentUser!.phoneNumber!
    );

    emit(UsernameLoading());

    if (event.username.isEmpty) {
      emit(UsernameSetError(message: "Please type something in!"));
      return;
    }

    await FirebaseAuth.instance.currentUser!.updateDisplayName(event.username);
    try {
      await userRef.update({
        "displayName": event.username
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    emit(UsernameSetSuccess());
  }
}
