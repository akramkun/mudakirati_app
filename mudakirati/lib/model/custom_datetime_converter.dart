import 'package:intl/intl.dart';

class CustomDateTimeConverter {
  String _ignoreSubMicro(String s) {
    if (s.length > 27) return s.substring(0, 26) + s[s.length - 1];
    return s;
  }

  String calculateDifference(String over) {
    //parse RFC3339 to datetime
    DateTime date = DateTime.parse(_ignoreSubMicro(over));
    DateTime now = DateTime.now();
    int def = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    switch (def) {
      case -1:
        return 'yesterday ${DateFormat('hh:mm a').format(date)}';

      case 0:
        return DateFormat('hh:mm a').format(date);

      default:
        return DateFormat.yMMMd().format(date);
    }
  }
}
