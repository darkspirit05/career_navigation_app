import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final void Function(String?) onChanged;

  const CustomRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      activeColor: AppColors.primary,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
