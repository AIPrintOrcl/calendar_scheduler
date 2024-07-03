import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
          await showModalBottomSheet<String>( /* <Schedule> : 반환 받는 값 */
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDay : selectedDay,
              );
            },
          );
          /// 스케쥴 추가 시 스케쥴 리스트가 갱신X => FutureBuilder가 다시 실행되어야 한다.
          /// FutureBuilder가 다시 실행되는 경우
          /// 1. future: GetIt.I<AppDatabase>().getSchedules(), 에 대한 변경이 있을 때
          /// 2. 상위 Build 함수가 다시 실행되었을 때 => setState(() {}); 이용하여 상위 Build 함수를 다시 실행한다.
          setState(() {});
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
                focusedDay: DateTime.now().toUtc(),
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
                  /// drift을 통해 활용하기 위한 FutureBuilder
                  child: FutureBuilder<List<ScheduleTableData>>(
                    future: GetIt.I<AppDatabase>().getSchedules(
                        selectedDay,
                    ),
                    builder: (context, snapshot) {
                      /// 에러가 발생할 경우 에러를 보여준다.
                      if(snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        );
                      }
                      /// 데이터가 없는 상태이고 연결 상태가 아닐 경우 => GetIt.I<AppDatabase>().getSchedules()를 처음 실행한 상태
                      if(!snapshot.hasData && 
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(), /* 로딩 중 표시*/
                        );
                      }

                      /// 선택한 일정의 스케쥴들을 데이터를 받는다.
                      final schedules = snapshot.data!;

                      return ListView.separated(/* ListView.builder - 보여줄 아이템을 미리 셋팅. */
                        /// 해당 날짜의 스케쥴 갯수
                        itemCount: schedules.length,
                        /// 화면에 위젯이 보일 때마다 실행. 즉 스케쥴이 20개이면 4개는 세팅하고 나머지 16개는 스크롤 내리면 표시함.
                        itemBuilder: (BuildContext context, int index) {
                          /// 선택된 날짜에 해당되는 일정 리스트로 저장
                          /// List<Schedule>
                          // final selectedSchedules = schedules[selectedDay]!;
                          // final scheduleModel = selectedSchedules[index];

                          final schedule = schedules[index];

                          return ScheduleCard(
                              startTime: schedule.startTime,
                              endTime: schedule.endTime,
                              content: schedule.content,
                              color: Color(
                                int.parse(
                                  'FF${schedule.color}',
                                  radix: 16,
                                ),
                              ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index){ /* separatorBuilder - 위젯 사이사이에 실행 */
                          return SizedBox(height: 8.0);
                        },
                      );
                    }
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

