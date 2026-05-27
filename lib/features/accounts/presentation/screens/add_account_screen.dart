import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/mixins/form_mixin.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/account_form_provider.dart';
import '../widgets/account_form_fields.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen>
    with FormMixin {
  final _controllers = AccountFormControllers();

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!validate()) return;
    final success = await ref.read(accountFormProvider.notifier).submit(
          nickname: _controllers.nickname.text,
          dpId: _controllers.dpId.text,
          username: _controllers.username.text,
          password: _controllers.password.text,
          crn: _controllers.crn.text,
          boid: _controllers.boid.text,
          bankId: _controllers.bankId.text,
        );
    if (!mounted) return;
    if (success) {
      context.showSnack('Account added');
      context.pop();
    } else {
      final error = ref.read(accountFormProvider).error;
      showSnackBar(error ?? 'Could not add account', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(accountFormProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add account')),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock, size: 18, color: context.colors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Your password is encrypted on this device and only '
                        'sent to MeroShare.',
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AccountFormFields(controllers: _controllers),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Save account',
                icon: Icons.save_outlined,
                isLoading: formState.isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
