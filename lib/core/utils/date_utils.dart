import 'package:intl/intl.dart';

/// IPO date formatting helpers.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _date = DateFormat('MMM d, yyyy');
  static final DateFormat _dateTime = DateFormat('MMM d, yyyy • h:mm a');

  static String formatDate(DateTime? dt) =>
      dt == null ? '—' : _date.format(dt.toLocal());

  static String formatDateTime(DateTime? dt) =>
      dt == null ? '—' : _dateTime.format(dt.toLocal());

  /// Parses MeroShare date strings, which may be ISO-8601 or `yyyy-MM-dd`.
  static DateTime? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw.trim());
  }

  /// Human countdown until [closeDate], e.g. "Closes in 2 days".
  static String closesIn(DateTime closeDate) {
    final diff = closeDate.difference(DateTime.now());
    if (diff.isNegative) return 'Closed';
    if (diff.inDays >= 1) return 'Closes in ${diff.inDays}d';
    if (diff.inHours >= 1) return 'Closes in ${diff.inHours}h';
    return 'Closes soon';
  }

  static bool isOpenNow(DateTime open, DateTime close) {
    final now = DateTime.now();
    return now.isAfter(open) && now.isBefore(close);
  }
}
