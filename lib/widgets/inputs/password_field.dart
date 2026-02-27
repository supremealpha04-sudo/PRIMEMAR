import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'text_field.dart';

class PasswordField extends HookWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    this.label = 'Password',
    this.hint,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(false);
    
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      obscureText: !isVisible.value,
      suffix: IconButton(
        icon: Icon(
          isVisible.value ? Icons.visibility_off : Icons.visibility,
          size: 20,
        ),
        onPressed: () => isVisible.value = !isVisible.value,
      ),
    );
  }
}
