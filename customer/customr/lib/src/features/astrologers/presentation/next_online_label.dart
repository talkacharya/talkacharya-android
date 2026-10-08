import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/l10n.dart';

/// "today, 5:00 PM" · "tomorrow, 9:00 AM" · "12 Oct, 9:00 AM" — when an
/// astrologer is back on a channel they have switched off until then.
String nextOnlineWhen(BuildContext context, DateTime at) {
  final l = context.l10n;
  final time = TimeOfDay.fromDateTime(at).format(context);
  final days = DateUtils.dateOnly(
    at,
  ).difference(DateUtils.dateOnly(DateTime.now())).inHours;
  if (days < 12) return l.astroNextOnlineToday(time);
  if (days < 36) return l.astroNextOnlineTomorrow(time);
  return l.astroNextOnlineDate(
    DateFormat('d MMM', l.localeName).format(at),
    time,
  );
}
