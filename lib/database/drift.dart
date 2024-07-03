import 'dart:io';

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
@DriftDatabase( /* 생성할 모든 테이블을 입력한다..*/
  tables: [ScheduleTable]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  ///쿼리 작성


  @override
  int get schemaVersion => 1; /* database의 컬럼 등 변경할 경우 버전 관리 */
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