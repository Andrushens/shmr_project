import 'package:shmr/generated/l10n.dart';

class DateFormatter {
  static final months = {
    1: S.current.january,
    2: S.current.february,
    3: S.current.march,
    4: S.current.april,
    5: S.current.march,
    6: S.current.june,
    7: S.current.july,
    8: S.current.august,
    9: S.current.september,
    10: S.current.october,
    11: S.current.november,
    12: S.current.december,
  };

  static String formatDate(DateTime date) {
    var formattedDate = '${date.day} ${months[date.month]} ${date.year}';
    return formattedDate;
  }
}
