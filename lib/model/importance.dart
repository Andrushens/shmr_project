import 'package:shmr/generated/l10n.dart';

enum Importance { none, low, high }

Importance importanceFromString(String value) {
  switch (value) {
    case 'low':
      return Importance.low;
    case 'important':
      return Importance.high;
    default:
      return Importance.none;
  }
}

String stringFromImportance(Importance? value) {
  switch (value) {
    case Importance.low:
      return 'low';
    case Importance.high:
      return 'important';
    default:
      return 'basic';
  }
}

String localizedStringFromImportance(Importance? value) {
  switch (value) {
    case Importance.low:
      return S.current.low;
    case Importance.high:
      return S.current.important;
    default:
      return S.current.basic;
  }
}
