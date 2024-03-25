import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:table_calendar/table_calendar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusDay){
    setState(() {
      today = day;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        color: colorScheme(context).background,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              TableCalendar(
                calendarFormat: CalendarFormat.week,
                locale: 'pt_BR',
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  formatButtonShowsNext: false, // Esconde a seta que mostra o próximo mês
                  leftChevronIcon: Icon(Symbols.arrow_back_ios, color: colorScheme(context).surface), // Personalize a seta esquerda
                  rightChevronIcon: Icon(Icons.arrow_forward_ios, color: colorScheme(context).surface), //
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) {
                  return isSameDay(today, day);
                },

                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                onDaySelected: _onDaySelected,
              ),
              FlutterFlowCalendar(
                color: Color(0xFF547B9A),
                iconColor: FlutterFlowTheme.of(context).secondaryText,
                weekFormat: true,
                weekStartsMonday: true,
                rowHeight: 52,
                onChange: (DateTimeRange? newSelectedDate) {
                  setState(() => _model.calendarSelectedDay = newSelectedDate);
                },
                titleStyle: TextStyle(
                  color: Color(0xFF474C51),
                  fontWeight: FontWeight.w500,
                ),
                dayOfWeekStyle: FlutterFlowTheme.of(context).labelLarge,
                dateStyle: TextStyle(
                  color: Color(0xFF474C51),
                  fontSize: 16,
                ),
                selectedDateStyle: FlutterFlowTheme.of(context).titleSmall,
                inactiveDateStyle: FlutterFlowTheme.of(context).labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
