import 'package:flutter/cupertino.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'package:pictro/utils/region.dart';
import 'package:pictro/widgets/custom_text_field.dart';

class PhoneField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final region = Region();

  String dialCode = "";

  @override
  void didChangeDependencies() {
    dialCode = region.getDialCode(context);
    widget.controller.text = dialCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hintText: dialCode,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        PhoneInputFormatter(allowEndlessPhone: false)
      ],
    );
  }
}
