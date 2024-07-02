import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;
  final bool Function(DateTime day) selectedDayPredicate;

  const Calendar({
    required this.focusedDay,
    required this.onDaySelected,
    required this.selectedDayPredicate,
    super.key,});

  @override
  Widget build(BuildContext context) {
    final defauultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1.0,
      ),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR', /* main에서 초기화한 intl패키지에 의해서 TableCalendar의 언어가 변경된다. */
      focusedDay: focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          )
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        /* 캘린더 날짜별 상자 테두리 */
        defaultDecoration: defauultBoxDecoration, /* 주간 스타일 */
        weekendDecoration: defauultBoxDecoration, /* 주말 스타일 */
        selectedDecoration: defauultBoxDecoration.copyWith( /* 선택한 날짜 스타일*/
          border: Border.all(
            color: primaryColor,
            width: 1.0,
          ),
        ),
        todayDecoration: defauultBoxDecoration.copyWith( /* 오늘 날짜 스타일 */
          color: primaryColor,
        ),
        outsideDecoration: defauultBoxDecoration.copyWith( /* 이달 외 날짜 */
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        /* 캘린더 날짜별 텍스트 스타일 */
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: primaryColor,
        ),
      ),
      onDaySelected: onDaySelected,
      selectedDayPredicate: selectedDayPredicate,
    );
  }
}
