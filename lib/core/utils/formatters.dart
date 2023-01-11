import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../config/localization/l10n/l10n.dart';
import 'globals.dart';

class DateFormatter {
  static String chatTime(String date) {
    initializeDateFormatting("ar");
    const Duration addedTime = Duration(hours: 2);
    return date.isNotEmpty
        ? DateTime.parse(date).add(addedTime).difference(DateTime.now()).inHours < 24
            ? DateFormat.jm(L10n.isAr(globalContext) ? "ar" : "en").format(DateTime.parse(date).add(addedTime))
            : DateFormat.yMd(L10n.isAr(globalContext) ? "ar" : "en").format(DateTime.parse(date).add(addedTime))
        : "";
  }
}
