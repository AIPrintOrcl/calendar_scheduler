import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/model/category.dart';
import 'package:calendar_scheduler/model/schedule.dart';

/// 카테고리 테이블과 스케쥴 테이블 정보를 담고 있는 클래스
class ScheduleWithCategory {
  final CategoryTableData category;
  final ScheduleTableData schedule;

  ScheduleWithCategory({
    required this.category,
    required this.schedule,
  });
}