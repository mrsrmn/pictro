import 'package:flutter/cupertino.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'package:pictro/utils/region.dart';
import 'package:pictro/widgets/custom_text_field.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  PhoneField({super.key, required this.controller});

  final region = Region();

  @override
  Widget build(BuildContext context) {
    String dialCode = region.getDialCode(context);
    controller.text = dialCode;

    return CustomTextField(
      controller: controller,
      hintText: dialCode,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        PhoneInputFormatter(allowEndlessPhone: false)
      ],
    );
  }
}
