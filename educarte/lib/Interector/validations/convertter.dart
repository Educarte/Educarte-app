import 'package:intl/intl.dart';

class Convertter {
  static Future<List<String>> getCurrentDate() async{
    DateTime now = DateTime.now();
    String locale = 'pt_BR';

    DateFormat startFormat = DateFormat('EEEE, dd', locale);
    String start = startFormat.format(now);
      
    start = start.replaceRange(0, 1, start[0].toUpperCase());

    String center = DateFormat(' MMMM', locale).format(now).toUpperCase();
    String end = DateFormat('yyyy', locale).format(now);

    return ["$start de", center, " de $end"];
  }
}