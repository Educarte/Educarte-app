import 'package:intl/intl.dart';

class IntlFormatter {
  static String getDayWeek(DateTime data) {
    List<String> diasSemana = [
      'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira',
      'Sexta-feira', 'Sábado', 'Domingo'
    ];

    String dayWeek = diasSemana[data.weekday - 1];

    return dayWeek;
  }


  static Future<(String day, String month, String year)> getCurrentDate({bool? isDe, String? data}) async{
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

    return ("$start de", center, isDe != null ? end : " de $end");
  }

  static String dateInMonthAndYear({required DateTime date}){
    final DateFormat normalize = DateFormat('MMMM, yyyy', 'pt_BR');

    return normalize.format(date);
  }

  static String formatTimeToHourMinutes(String date) {
    DateTime dateTime = DateTime.parse(date).add(const Duration(hours: -3));

    String formattedHour = DateFormat('HH', 'pt_BR').format(dateTime);
    String formattedMinutes = DateFormat('mm', 'pt_BR').format(dateTime);

    String result = '${formattedHour}h. ${formattedMinutes}min';

    return result;
  }
}