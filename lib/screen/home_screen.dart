import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
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

  ///
  Map<DateTime, List<Schedule>> schedules = {
    DateTime.utc(2024, 7, 2): [
      Schedule(
          id: 1,
          startTime: 11,
          endTime: 12,
          content: '플러터 공부하기',
          date: DateTime.utc(2024, 7, 2),
          color: categoryColors[0],
          createdAt: DateTime.now().toUtc(),
      ),
      Schedule(
        id: 2,
        startTime: 14,
        endTime: 15,
        content: '플러터 복습하기',
        date: DateTime.utc(2024, 7, 2),
        color: categoryColors[3],
        createdAt: DateTime.now().toUtc(),
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton( /* 스케쥴 추가 버튼 */
        onPressed: (){
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return ScheduleBottomSheet();
              },
          );
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              focusedDay: DateTime(2024, 7, 1),
              onDaySelected: onDaySelected,
              selectedDayPredicate: selectedDayPredicate,
            ),
            TodayBanner(
              selectedDay : selectedDay,
              taskCount: 0,
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: ListView(
                    children: schedules.containsKey(selectedDay) /* 선택한 날짜가 null 값일 경우  */
                      ? schedules[selectedDay]!
                        .map(
                          (e) => ScheduleCard(
                            startTime: e.startTime,
                            endTime: e.endTime,
                            content: e.content,
                            color: Color(
                              int.parse(
                                'FF${e.color}',
                                radix: 16,
                              ),
                            ),
                          ),
                    ).toList(),
                  ),
                )
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

