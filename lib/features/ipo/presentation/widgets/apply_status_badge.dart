import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/apply_status.dart';
import '../providers/open_ipos_provider.dart';

/// Summarises how many saved accounts have applied for a given IPO.
class ApplyStatusBadge extends ConsumerWidget {
  const ApplyStatusBadge({super.key, required this.companyShareId});

  final String companyShareId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(applicationsProvider).valueOrNull ?? const [];
    final mine =
        apps.where((a) => a.companyShareId == companyShareId).toList();
    final applied =
        mine.where((a) => a.status == ApplyStatus.applied).length;

    if (mine.isEmpty) {
      return _pill(context, 'Not applied', AppliedTone.neutral);
    }
    if (mine.any((a) => a.status == ApplyStatus.error)) {
      return _pill(context, '$applied applied • errors', AppliedTone.error);
    }
    return _pill(context, '$applied applied', AppliedTone.success);
  }

  Widget _pill(BuildContext context, String text, AppliedTone tone) {
    final color = switch (tone) {
      AppliedTone.success => ApplyStatus.applied.color,
      AppliedTone.error => ApplyStatus.error.color,
      AppliedTone.neutral => Theme.of(context).disabledColor,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

enum AppliedTone { success, error, neutral }
