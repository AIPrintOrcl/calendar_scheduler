import 'dart:io';

import 'package:calendar_scheduler/model/category.dart';
import 'package:calendar_scheduler/model/schedule_with_category.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p; /* path.dart 안에 있는 모든 기능들을 p라는 변수에 넣어 불러온다. */

import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

/// 코드 제노레이션 : 앱 데이터베이스의 기능을 자동으로 생성
part 'drift.g.dart'; /* g : 코드 제노레이션. drift.dart를 코드 제노레이션한다.
 터미널에서 dart run build_runner build 입력*/

/// 휴대폰마다 앱을 설치할 때 필요한 Database 파일을 저장할 공간(폴더)를 생성하고 database를 생성한다.
@DriftDatabase(tables: [ /* 생성할 모든 테이블을 입력한다..*/
  ScheduleTable,
  CategoryTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /*-----쿼리 시작------*/
  /* drift 실행을 통해 생성된 클래스
      1. 테이블명+Data : 데이터를 가져올 때 사용. 실제로 DB에서 가져오는 타입 또는 데이터를 넣을 때의 타입
      2. 테이블명+Companion : 데이터를 업데이트하거나  생성할 때 사용
  * */
  /// 선택한 일정의 스케쥴 데이터 검색 쿼리
  // Future<List<ScheduleTableData>> getSchedules(
  //     DateTime date, /* 선택한 일정 */
  // ) => (select(scheduleTable)..where((table) => table.date.equals(date))).get(); /* ..where() : where()에 대한 결과 값을 반환하는 것이 아닌 where을 실행한 대상(select(scheduleTable))을 반환할 것이다. */

  Stream<List<ScheduleWithCategory>> streamSchedules(
      DateTime date, /* 선택한 일정 */
  ) {
    final query = select(scheduleTable).join(
        [
          innerJoin(
            categoryTable,
            categoryTable.id.equalsExp( /* equalsExp : drift의 equals() */
              scheduleTable.colorId,
            ),
          ),
        ])..where(scheduleTable.date.equals(date),
    )
    ..orderBy([ /* 정렬 */
          OrderingTerm( /* 1번째 기준 우선순위 */
            expression: scheduleTable.startTime,
            mode: OrderingMode.asc,
          ),
          OrderingTerm( /* 2번째 기준 우선순위 */
            expression: scheduleTable.endTime,
            mode: OrderingMode.asc,
          ),
    ]);

    /// join으로 연결된 결과를 갖고서 각각의 row를 다시 맵핑시킨다.
    return query.map((row) {
      final schedule = row.readTable(scheduleTable);
      final category = row.readTable(categoryTable);
      
      return ScheduleWithCategory(category: category, schedule: schedule);
    }).watch();
  }
  //   => (select(scheduleTable)
  //     ..where( /* 필터 */
  //           (table) => table.date.equals(date),
  //     )
  //     ..orderBy([ /* 정렬 */
  //           (table) => OrderingTerm( /* 1번째 기준 우선순위 */
  //         expression: table.startTime,
  //         mode: OrderingMode.asc,
  //       ),
  //           (table) => OrderingTerm( /* 2번째 기준 우선순위 */
  //         expression: table.endTime,
  //         mode: OrderingMode.asc,
  //       ),
  //     ]))
  //       .watch(); /* ..where() : where()에 대한 결과 값을 반환하는 것이 아닌 where을 실행한 대상(select(scheduleTable))을 반환할 것이다. */


  // { 위 한줄 코드를 이지하게 풀기.
  //   final selectQuery = select(scheduleTable); /* 전체 스케쥴 데이터 */
  //   selectQuery.where((table) => table.date.equals(date)); /* 조건을 선택한 일정만 스케쥴 데이터를 필터 */
  //
  //   return selectQuery.get(); /* SQL 쿼리로 변경 */
  //
  // }

  /// 스케쥴 추가 쿼리
  Future<int> createSchedule(ScheduleTableCompanion data) => into(scheduleTable)
      .insert(data); /* scheduleTable에 데이터를 넣겠다. */

  /// 스케쥴 삭제 쿼리
  Future<int> removeSchedule(int id) => (delete(scheduleTable)
    ..where((table) => table.id.equals(id))).go();

  /// 스케쥴 수정 쿼리
  Future<int> updateScheduleById(int id, ScheduleTableCompanion data) =>
      (update(scheduleTable)..where((table) => table.id.equals(id))).write(data);

  /// 하나의 스케쥴 id 검색 쿼리. 수정할 스케쥴 정보 가져오기 위함.
  Future<ScheduleWithCategory> getScheduleById(int id) {
    final query = select(scheduleTable).join(
        [
          innerJoin(
            categoryTable,
            categoryTable.id.equalsExp( /* equalsExp : drift의 equals() */
              scheduleTable.colorId,
            ),
          ),
        ])..where(scheduleTable.id.equals(id));

    /// join으로 연결된 결과를 갖고서 각각의 row를 다시 맵핑시킨다.
    return query.map((row) {
      final schedule = row.readTable(scheduleTable);
      final category = row.readTable(categoryTable);

      return ScheduleWithCategory(category: category, schedule: schedule);
    }).getSingle();
  }

  /// 모든 카테고리 검색
  Future<List<CategoryTableData>> getCategories() => select(categoryTable).get();

  /// 카테고리 생성
  Future<int> createCategory(CategoryTableCompanion data) => into(categoryTable).insert(data);

  /*-----쿼리 끝------*/
  @override
  int get schemaVersion => 1; /* database의 컬럼 등 변경할 경우 버전 관리. 테이블을 변경하는 부분은 마이그레이션에 해당되는 부분 */
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory(); /* 휴대폰마다 App을 설치할 경우 각각에 하나의 앱마다 제공해 주는 Documents폴더의 위치를 가져오는 기능 */
    final file = File(p.join(dbFolder.path, 'db.sqlite')); /* 파일 불러오기. 주의! dart:io를 임폴트 할 것 */
    /// p.join : 현재재 운영체제 맞게 알아서 여러 경로를 합쳐줌.p.join(파일경로, 파일명);

    /// 예외처리
    if(Platform.isAndroid) { /* 플랫폼이 안드로이드일 경우 */
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions(); /* 옛날 버전의 안드로이드 버그를 해결 */
    }

    /// 임시 파일들을 적요하는 폴더 지정. - sqlite를 실행하면서 쓸데없는 파일들을 저장하는 위치 지정.
    final cachebase = await getTemporaryDirectory();

    sqlite3.tempDirectory = cachebase.path;

    /// _openConnection을 실행하면 지정한 file에 database를 생성한다.
    return NativeDatabase.createInBackground(file);

  },);
}