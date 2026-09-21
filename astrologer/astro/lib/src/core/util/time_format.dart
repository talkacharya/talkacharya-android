import 'package:intl/intl.dart';

import '../l10n/l10n.dart';

/// Short, localised timestamps for lists.
class TimeFormat {
  const TimeFormat._();

  /// "Just now" · "5m ago" · "3h ago" · "Yesterday" · "12 Sep".
  static String relative(AppLocalizations l, DateTime? at, {DateTime? now}) {
    if (at == null) return '';
    final n = now ?? DateTime.now();
    final local = at.toLocal();
    final diff = n.difference(local);
    if (diff.inMinutes < 1) return l.timeJustNow;
    if (diff.inMinutes < 60) return l.timeMinutesAgo(diff.inMinutes);
    if (_sameDay(local, n)) return l.timeHoursAgo(diff.inHours);
    if (_sameDay(local, n.subtract(const Duration(days: 1)))) {
      return l.timeYesterday;
    }
    return DateFormat.MMMd(l.localeName).format(local);
  }

  /// Section label for a day: "Today" · "Yesterday" · "Mon, 12 Sep".
  static String day(AppLocalizations l, DateTime at, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final local = at.toLocal();
    if (_sameDay(local, n)) return l.timeToday;
    if (_sameDay(local, n.subtract(const Duration(days: 1)))) {
      return l.timeYesterday;
    }
    return DateFormat.MMMEd(l.localeName).format(local);
  }

  /// "4:05 PM" in the user's locale.
  static String clock(AppLocalizations l, DateTime at) =>
      DateFormat.jm(l.localeName).format(at.toLocal());

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
