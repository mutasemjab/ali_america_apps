import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/theme/app_colors.dart';

class PhoneField extends StatelessWidget {
  final void Function(String fullNumber) onChanged;
  final String? initialValue;

  const PhoneField({super.key, required this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialCountryCode: 'US',
      initialValue: initialValue,
      decoration: const InputDecoration(
        labelText: 'Phone number',
        filled: true,
        fillColor: AppColors.surfaceMuted,
      ),
      dropdownIconPosition: IconPosition.trailing,
      flagsButtonPadding: const EdgeInsets.only(left: 12),
      onChanged: (phone) => onChanged(phone.completeNumber),
    );
  }
}
