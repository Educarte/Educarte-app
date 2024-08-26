import 'package:intl/intl.dart';

class Convertter {
  static Future<List<String>> getCurrentDate({bool? isDe, String? data}) async{
    DateTime now = DateTime.now();
    String locale = 'pt_BR';
    if(data != null){
      now = DateTime.parse(data);
    }
    DateFormat startFormat = DateFormat(isDe != null ? 'dd' :'EEEE, dd', locale);
    String start = startFormat.format(now);
      
    start = start.replaceRange(0, 1, start[0].toUpperCase());

    String center = DateFormat(' MMMM', locale).format(now).toUpperCase();
    String end = DateFormat('yyyy', locale).format(now);

    return ["$start de", center, isDe != null ? end : " de $end"];
  }

  static String dateInMonthAndYear({required DateTime date}){
    final DateFormat normalize = DateFormat('MMMM, yyyy', 'pt_BR');

    return normalize.format(date);
  }
}