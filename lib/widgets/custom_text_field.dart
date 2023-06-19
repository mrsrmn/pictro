import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? fontFamily;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.inputFormatters,
    this.initialValue,
    this.fontFamily,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: fontFamily,
        color: Colors.white
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white54
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(width: 2)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2
          )
        ),
      ),
    );
  }
}