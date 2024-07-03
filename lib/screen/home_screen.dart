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
  DateTime selectedDay = DateTime.utc(/* 초기 선택한 날짜를 현재 날짜로 미리 셋팅 */
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  ///
  // Map<DateTime, List<Schedule>> schedules = {
  //   DateTime.utc(2024, 7, 2): [
  //     Schedule(
  //       id: 1,
  //       startTime: 11,
  //       endTime: 12,
  //       content: '플러터 공부하기',
  //       date: DateTime.utc(2024, 7, 2),
  //       color: categoryColors[0],
  //       createdAt: DateTime.now().toUtc(),
  //     ),
  //     Schedule(
  //       id: 2,
  //       startTime: 14,
  //       endTime: 15,
  //       content: '플러터 복습하기',
  //       date: DateTime.utc(2024, 7, 2),
  //       color: categoryColors[3],
  //       createdAt: DateTime.now().toUtc(),
  //     ),
  //   ],
  // };

  @override
  Widget build(BuildContext context) {
    /// 1. 새로운 스케쥴 추가
    return Scaffold(
      floatingActionButton: FloatingActionButton(/* 스케쥴 추가 버튼 */
        onPressed: () async {
          final schedule = await showModalBottomSheet<String>( /* <Schedule> : 반환 받는 값 */
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDay : selectedDay,
              );
            },
          );
          /// 3. 새로운 스케쥴 추가
          /// 스케쥴 추가 안할 경우
          if(schedule == null){
            return;
          }

          /// 기존에 있던 스케쥴에 추가한 스케쥴을 입력
          /// 1) 하드버전
          // setState(() {
          //   schedules = { /* Map schedules */
          //     ...schedules, /* Map schedules에 기존에 존재하던 스케쥴을 입력한다. */
          //     schedule.date: [ /* schedules의 date를 키값으로 */
          //       if(schedules.containsKey(schedule.date)) /* 반환 받은 일정에 스케쥴이 존재하면 */
          //         ...schedules[schedule.date]!, /* 기존에 있던 스케줄을 입력하고 */
          //       schedule, /* 기존에 있던 스케쥴 뒤에 새로 만든 스케쥴을 입력한다. */
          //     ]
          //   };
          // });
          // /// 2) 이지버전
          // final dateExists = schedules.containsKey(schedule.date); /* 선택한 일정에 기존 스케쥴 존재 확인 */
          //
          // final List<Schedule> existingSchedules = dateExists ? schedules[schedule.date]! : []; /* 만약 기존 스케쥴이 존재할 경우 기존 스케쥴을 가져온다. 존재하지 않을 경우 빈 리스트를 가져온다. */
          //
          // /// 기존 스케쥴이 있을 경우 : [기존 Schedule, 추가된 Schedule]
          // /// 기존 스케쥴이 없을 경우 : [추가된 Schedule]
          // existingSchedules!.add(schedule); /* 추가한 스케쥴을 입력한다. */
          //
          // setState(() {
          //   schedules = {
          //     ...schedules, /* 기존 스케쥴을 입력하고 */
          //     schedule.date: existingSchedules, /* 선택한 일정을 키값으로 추가한 스케쥴을 입력한다. */
          //   };
          // });
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
                selectedDay: selectedDay,
                taskCount: 0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0),
                  child: ListView.separated(/* ListView.builder - 보여줄 아이템을 미리 셋팅. */
                    /// 해당 날짜의 스케쥴 갯수
                    itemCount: 0 /*schedules
                        .containsKey(*//* containsKey : 해당 키값이 존재 여부 확인*//*
                        selectedDay
                    ) ? schedules[selectedDay]!.length : 0*/,
                    /// 화면에 위젯이 보일 때마다 실행. 즉 스케쥴이 20개이면 4개는 세팅하고 나머지 16개는 스크롤 내리면 표시함.
                    itemBuilder: (BuildContext context, int index) {
                      /// 선택된 날짜에 해당되는 일정 리스트로 저장
                      /// List<Schedule>
                      // final selectedSchedules = schedules[selectedDay]!;
                      // final scheduleModel = selectedSchedules[index];

                      return ScheduleCard(
                          startTime: 12,
                          endTime: 14,
                          content: 'scheduleModel.content',
                          color: Color(
                            int.parse(
                              'FF000000',
                              radix: 16,
                            ),
                          ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index){ /* separatorBuilder - 위젯 사이사이에 실행 */
                      return SizedBox(height: 8.0);
                    },
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

  bool selectedDayPredicate(DateTime date) {
    if (selectedDay == null) {
      return false;
    }
    return date.isAtSameMomentAs(selectedDay!);
  }

}

