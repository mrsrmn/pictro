import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:scribble/pages/register/sms_code_page.dart';

import 'package:scribble/widgets/custom_button.dart';
import 'package:scribble/widgets/phone_field.dart';
import 'package:scribble/utils/region.dart';
import 'package:scribble/utils/utils.dart';
import 'package:scribble/utils/auth.dart';
import 'package:scribble/utils/constants.dart';
import 'package:scribble/injection_container.dart';
import 'package:scribble/bloc/register_bloc.dart';


class Register extends StatelessWidget {
  Register({super.key});

  final TextEditingController _controller = TextEditingController();
  final Region region = Region();
  final RegisterBloc bloc = sl<RegisterBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(15),
          color: Colors.black87,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Phone Number", style: TextStyle(color: Colors.white, fontSize: 23), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                PhoneField(controller: _controller),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () {
                    bloc.add(RegisterValidateNumber(value: _controller.text));
                  },
                  backgroundColor: Colors.purple.shade500,
                  child: BlocBuilder(
                    bloc: bloc,
                    builder: (BuildContext context, state) {
                      if (state is RegisterCheckingPhone) {
                        return const Center(child: CupertinoActivityIndicator());
                      } else if (state is RegisterPhoneEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          Utils.alertPopup(context, "Please enter a phone number!");
                        });
                      } else if (state is RegisterPhoneInvalid) {
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          Utils.alertPopup(context, "Please enter a valid phone number!");
                        });
                      } else if (state is RegisterPhoneValid) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Authentication.instance.sendSMS(_controller.text);
                          Get.to(() => SmsCodePage());
                        });
                      }

                      return const Text(
                        "Register",
                        style: TextStyle(
                          fontFamily: geologicaMedium,
                          fontSize: 19,
                          color: Colors.white,
                        )
                      );
                    }
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
