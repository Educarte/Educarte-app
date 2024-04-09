import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:educarte/Interector/validations/convertter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Interector/base/constants.dart';

class CustomTableCalendar extends StatefulWidget {
  const CustomTableCalendar({
    super.key,
    required this.callback,
    this.paddingTop
  });
  final Function(DateTime? start, DateTime? end)? callback;
  final double? paddingTop;

  @override
  State<CustomTableCalendar> createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? currentDay;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  late PageController _pageController;
  Duration duration = const Duration(milliseconds: 400);
  Curve curve = Curves.decelerate;
  String currentDate = Convertter.dateInMonthAndYear(date: DateTime.now());
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  @override
  void initState() {
    super.initState();
  }

  void showCalendar({required DateTime init, required DateTime last}) {
    showCalendarDatePicker2Dialog(
        context: context,
        dialogSize: const Size(325, 400),
        borderRadius: BorderRadius.circular(15),
        config: CalendarDatePicker2WithActionButtonsConfig(
          firstDayOfWeek: 1,
          calendarType: CalendarDatePicker2Type.range,
          selectedDayTextStyle: textTheme(context).displayLarge!.copyWith(
              color: colorScheme(context).onBackground
          ),
          selectedDayHighlightColor: Colors.purple[800],
          centerAlignModePicker: true,
          customModePickerIcon: const SizedBox(),
        ),
        value: const []
    ).then((value) {
      if(value == null){
        return;
      }else{
        if(value.length > 1){
          setRange(
              startValue: value.first,
              endValue: value.last
          );
        }

        setSelectedDay(value: value.first);
        setFocusedDay(value: value.first!);
      }
    });
  }

  void setFocusedDay({required DateTime value}) {
    setState(() {
      _focusedDay = value;
    });
  }

  void setSelectedDay({DateTime? value}) {
    setState(() {
      currentDay = value!;
    });
  }


  void setRange({DateTime? startValue, DateTime? endValue}) => setState(() {
    _startDate = startValue!;
    _endDate = endValue;
    widget.callback!(_startDate,_endDate);
  });

  void pageChanged({required DateTime newFocusedDay}) => setState(() {
    _focusedDay = newFocusedDay;

    currentDate = Convertter.dateInMonthAndYear(date: newFocusedDay);
  });

  void previousPage() => _pageController.previousPage(duration: duration, curve: curve);

  void nextPage() => _pageController.nextPage(duration: duration, curve: curve);

  @override
  Widget build(BuildContext context) {
    double iconSize = 24;
    int limitDate = 365 * 2;
    DateTime dateNow = DateTime.now();
    TextStyle daysOfWeekStyle = textTheme(context).headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
      fontSize: 20
    );
    BoxDecoration selectedDecoration ({double? withOpacity = 1}) => BoxDecoration(
        color: colorScheme(context).primary.withOpacity(withOpacity!),
        shape: BoxShape.circle
    );
    DateTime initDate = dateNow.subtract(Duration(days: limitDate));
    DateTime lastDate = dateNow.add(Duration(days: limitDate));

    return Expanded(
      flex: 0,
      child: Padding(
        padding: EdgeInsets.only(top: widget.paddingTop ?? 16),
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                            currentDate,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: colorScheme(context).surface
                          ),
                        )
                    ),
                    Expanded(
                        flex: 0,
                        child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => showCalendar(
                                    init: initDate,
                                    last: lastDate
                                ),
                                child: Icon(
                                    Icons.calendar_month_outlined,
                                    size: iconSize,
                                    color: colorScheme(context).surface
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () => previousPage(),
                                child: Icon(
                                    Icons.arrow_back_ios,
                                    size: iconSize,
                                    color: colorScheme(context).surface
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => nextPage(),
                                child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: iconSize,
                                    color: colorScheme(context).surface
                                ),
                              )
                            ]
                        )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TableCalendar(
                  currentDay: currentDay,
                  rangeStartDay: _startDate,
                  rangeEndDay: _endDate,
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.week,
                  rangeSelectionMode: _rangeSelectionMode,
                  locale: 'pt_BR',
                  firstDay: initDate,
                  lastDay: lastDate,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  daysOfWeekHeight: 30,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: daysOfWeekStyle,
                    weekendStyle: daysOfWeekStyle,
                    dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0].toUpperCase(),
                  ),
                  calendarStyle: CalendarStyle(
                    rangeStartDecoration: selectedDecoration(),
                    rangeEndDecoration: selectedDecoration(withOpacity: 0.7),
                    rangeHighlightColor: colorScheme(context).primary.withOpacity(0.3),
                  ),
                  onPageChanged: (currentFocusedDay) => pageChanged(newFocusedDay: currentFocusedDay),
                  onCalendarCreated:(pageController) => _pageController = pageController,
                  onRangeSelected: (start, end, currentFocusedDay) {
                    setRange(
                        startValue: start,
                        endValue: end
                    );
                    setSelectedDay(value: start);
                    setFocusedDay(value: start!);
                  }
              )
            ]
        ),
      ),
    );
  }
}