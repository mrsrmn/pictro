import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:pictro/pages/register/sms_code_page.dart';
import 'package:pictro/widgets/custom_button.dart';
import 'package:pictro/widgets/phone_field.dart';
import 'package:pictro/utils/region.dart';
import 'package:pictro/utils/utils.dart';
import 'package:pictro/utils/auth.dart';
import 'package:pictro/utils/constants.dart';
import 'package:pictro/injection_container.dart';
import 'package:pictro/bloc/register/register_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController controller = TextEditingController();

  final Region region = Region();

  final RegisterBloc bloc = sl<RegisterBloc>();

  bool checkedValue = false;

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
                PhoneField(controller: controller),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: ExcludeSemantics(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "I have read the ",
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                                color: Colors.blue
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              launchUrl(Uri.parse(
                                "https://www.freeprivacypolicy.com/live/3ade9efb-65ab-4616-a478-a379e81721a7"
                              ));
                            }
                          ),
                          const TextSpan(
                            text: " and accept it.",
                          )
                        ]
                      ),
                    ),
                  ),
                  value: checkedValue,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedValue = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();

                    if (!checkedValue) {
                      Get.snackbar(
                        "Error!",
                        "You need to accept our Privacy Policy in order to use Pictro!",
                        colorText: Colors.white,
                        icon: const Icon(Icons.warning_amber, color: Colors.red),
                      );
                      return;
                    }
                    bloc.add(RegisterValidateNumber(value: controller.text));
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
                          try {
                            Authentication.instance.sendSMS(controller.text);
                          } catch (e) {
                            print(e.toString());
                          }
                          Get.to(() => const SmsCodePage());
                        });
                      }

                      return const Text(
                        "Register / Sign In",
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
