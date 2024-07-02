import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc( /* 초기 선택한 날짜를 현재 날짜로 미리 셋팅 */
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              focusedDay: DateTime(2024, 7, 1),
              onDaySelected: onDaySelected,
              selectedDayPredicate: selectedDayPredicate,
            ),
            Container(
              color: primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '0개',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focuseDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }

  bool selectedDayPredicate (DateTime date){
    if(selectedDay == null){
      return false;
    }
    return date.isAtSameMomentAs(selectedDay!);
  }

}

