import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:scribble/bloc/username/username_bloc.dart';
import 'package:scribble/injection_container.dart';
import 'package:scribble/utils/constants.dart';
import 'package:scribble/widgets/custom_button.dart';
import 'package:scribble/widgets/custom_text_field.dart';

class ChangeUsername extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final UsernameBloc bloc = sl<UsernameBloc>();
  final Widget initialChild = const Text("Ok", style: TextStyle(
    fontFamily: geologicaMedium,
    fontSize: 19,
    color: Colors.black87,
  ));

  ChangeUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        bool enabled = true;

        return CustomButton(
          onPressed: () {
            HapticFeedback.lightImpact();

            showDialog(
              context: context,
              builder: (BuildContext context) {
                Widget usernameButtonChild = BlocBuilder(
                  bloc: bloc,
                  builder: (BuildContext context, state) {
                    if (state is UsernameLoading) {
                      enabled = false;
                      return const CupertinoActivityIndicator(color: Colors.black);
                    } else if (state is UsernameSetError) {
                      Get.snackbar(
                        "Error!",
                        "We couldn't change your username.",
                        colorText: Colors.white,
                        icon: const Icon(Icons.warning_amber, color: Colors.red),
                        shouldIconPulse: false
                      );
                      enabled = true;
                      return initialChild;
                    } else if (state is UsernameSetSuccess) {
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Get.snackbar(
                          "Success!",
                          "Your username has been changed to ${controller.text}",
                          colorText: Colors.white,
                          icon: const Icon(Icons.verified_outlined, color: Colors.green)
                        );
                      });

                      return initialChild;
                    }

                    return initialChild;
                  },
                );

                return AlertDialog(
                  title: const Text("Change username", style: TextStyle(
                    color: Colors.white,
                    fontFamily: geologicaBold,
                    fontSize: 18
                  )),
                  content: CustomTextField(
                    hintText: "Type in an username",
                    controller: controller,
                    keyboardType: TextInputType.text,
                    maxLength: 14,
                  ),
                  actions: [
                    CustomButton(
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white.withOpacity(.9),
                      foregroundColor: Colors.black87,
                      text: "Cancel",
                    ),
                    CustomButton(
                      onPressed: () {
                        if (enabled) {
                          bloc.add(SetUsernameOfUser(username: controller.text));
                        }
                      },
                      backgroundColor: Colors.white.withOpacity(.9),
                      foregroundColor: Colors.black87,
                      child: usernameButtonChild,
                    )
                  ],
                );
              }
            );
          },
          backgroundColor: Colors.white.withOpacity(.9),
          foregroundColor: Colors.black87,
          text: "Change Username",
        );
      }
    );
  }
}