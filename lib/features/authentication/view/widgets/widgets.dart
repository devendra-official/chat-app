import 'package:flutter/material.dart';
import 'package:messenger/core/themes/colors.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({
    super.key,
    required this.controller,
    this.inputType,
    this.validator,
    required this.label,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final String label;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: true,
      obscureText: isPassword,
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: greyTextColor)
        ),
        labelText: label,
        labelStyle: const TextStyle(color: greyTextColor),
        contentPadding: const EdgeInsets.all(24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.value, this.onTap});

  final String value;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
            color: blueColor, borderRadius: BorderRadius.circular(24)),
        child: Center(
          child: Text(
            "Log in",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }
}
