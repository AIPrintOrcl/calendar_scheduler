import 'package:drift/drift.dart';

class ScheduleTable extends Table{
  /// 1) 식별 가능한 ID
  IntColumn get id => integer().autoIncrement()(); /* ()()함수를 다시 한번 실행 */
  /// 2) 시작 시간
  IntColumn get startTime => integer()();
  /// 3) 종료 시간
  IntColumn get endTime => integer()();
  /// 4) 일정 내용
  TextColumn get content => text()();
  /// 5) 날짜
  DateTimeColumn get date => dateTime()();
  /// 6) 카테고리
  TextColumn get color => text()();
  /// 7) 일정 생성날짜시간
  DateTimeColumn get createdAt => dateTime().clientDefault(
      () => DateTime.now().toUtc(),
  )();
}