import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';
import '../../shared/widgets/app_button.dart';
import '../di/providers.dart';
import '../theme/app_spacing.dart';
import 'router_guards.dart';

/// Full-screen biometric gate shown when the app lock is engaged.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);
    final ok = await ref
        .read(biometricServiceProvider)
        .authenticate(reason: 'Unlock ${AppConstants.appName}');
    if (!mounted) return;
    setState(() => _authenticating = false);
    if (ok) ref.read(appLockProvider.notifier).unlock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 72, color: context.colors.primary),
              const SizedBox(height: AppSpacing.lg),
              Text(AppConstants.appName, style: context.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text('Locked', style: context.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: 220,
                child: AppButton(
                  label: 'Unlock',
                  icon: Icons.fingerprint,
                  isLoading: _authenticating,
                  onPressed: _authenticate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
