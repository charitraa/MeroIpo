import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../domain/entities/ipo_entity.dart';
import '../providers/apply_provider.dart';

/// FAB that applies every auto-apply-enabled account to [ipo].
class BulkApplyFab extends ConsumerWidget {
  const BulkApplyFab({super.key, required this.ipo});

  final IpoEntity ipo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applyState = ref.watch(applyProvider);
    final enabledCount = ref.watch(autoApplyEnabledCountProvider);

    return FloatingActionButton.extended(
      onPressed: applyState.isApplying || enabledCount == 0
          ? null
          : () => _apply(context, ref),
      icon: applyState.isApplying
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : const Icon(Icons.rocket_launch_outlined),
      label: Text(
        applyState.isApplying
            ? 'Applying…'
            : 'Apply all ($enabledCount)',
      ),
    );
  }

  Future<void> _apply(BuildContext context, WidgetRef ref) async {
    await ref.read(applyProvider.notifier).applyAll(ipo);
    if (!context.mounted) return;
    final state = ref.read(applyProvider);
    if (state.error != null) {
      context.showSnack(state.error!, isError: true);
    } else {
      context.showSnack(
        'Applied for ${state.appliedCount} account(s)'
        '${state.errorCount > 0 ? ', ${state.errorCount} failed' : ''}',
        isError: state.errorCount > 0,
      );
    }
  }
}
