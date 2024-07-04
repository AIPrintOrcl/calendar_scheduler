import 'package:drift/drift.dart';

/// 카테고리에 Join하여 다른 테이블과 연결하고 작업 가능하도록 카테고리 테이블을 따로 만들어서 관리
class CategoryTable extends Table{
  IntColumn get id => integer().autoIncrement()(); /* 카테고리 id. join으로 사용할 기본키 */

  TextColumn get color => text()();

  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now().toUtc(),
  )();
}