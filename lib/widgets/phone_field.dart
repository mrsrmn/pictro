import 'package:flutter/cupertino.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'package:scribble/utils/region.dart';
import 'package:scribble/widgets/custom_text_field.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  PhoneField({super.key, required this.controller});

  final region = Region();

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: "+1",
      keyboardType: TextInputType.phone,
      initialValue: region.getDialCode(context),
      inputFormatters: [
        PhoneInputFormatter(allowEndlessPhone: false)
      ],
    );
  }
}
