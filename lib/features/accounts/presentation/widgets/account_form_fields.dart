import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// Groups all the text controllers for the add-account form so the screen
/// stays tidy. The parent owns disposal.
class AccountFormControllers {
  final nickname = TextEditingController();
  final dpId = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final crn = TextEditingController();
  final boid = TextEditingController();
  final bankId = TextEditingController();

  void dispose() {
    nickname.dispose();
    dpId.dispose();
    username.dispose();
    password.dispose();
    crn.dispose();
    boid.dispose();
    bankId.dispose();
  }
}

/// The set of input fields used to create an account.
class AccountFormFields extends StatefulWidget {
  const AccountFormFields({super.key, required this.controllers});

  final AccountFormControllers controllers;

  @override
  State<AccountFormFields> createState() => _AccountFormFieldsState();
}

class _AccountFormFieldsState extends State<AccountFormFields> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final c = widget.controllers;
    return Column(
      children: [
        AppTextField(
          label: 'Nickname',
          controller: c.nickname,
          hint: "e.g. Hari's account",
          prefixIcon: Icons.badge_outlined,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.required(v, field: 'Nickname'),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'DP id',
          controller: c.dpId,
          hint: 'e.g. 13200',
          prefixIcon: Icons.account_balance_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.next,
          validator: Validators.dpId,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Username',
          controller: c.username,
          prefixIcon: Icons.person_outline,
          textInputAction: TextInputAction.next,
          validator: Validators.username,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Password',
          controller: c.password,
          obscureText: _obscure,
          prefixIcon: Icons.lock_outline,
          textInputAction: TextInputAction.next,
          validator: Validators.password,
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'CRN',
          controller: c.crn,
          prefixIcon: Icons.confirmation_number_outlined,
          textInputAction: TextInputAction.next,
          validator: Validators.crn,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'BOID (demat)',
          controller: c.boid,
          hint: '16-digit demat number',
          prefixIcon: Icons.credit_card_outlined,
          keyboardType: TextInputType.number,
          maxLength: AppConstants.boidLength,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.next,
          validator: Validators.boid,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Bank id',
          controller: c.bankId,
          hint: 'ASBA bank account id',
          prefixIcon: Icons.account_balance_wallet_outlined,
          textInputAction: TextInputAction.done,
          validator: (v) => Validators.required(v, field: 'Bank id'),
        ),
      ],
    );
  }
}
