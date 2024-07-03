import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  /* 프레임워크 실행할 준비가 되어있는지 확인하는 절차
  * runApp()실행 하기 전 다른 함수를 실행하고 싶다면 이 함수를 실행해줘야 한다. */
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(); /* 날짜 포맷 초기화 */

  /// 앱 데이터베이스에서 데이터 가져오기
  final database = AppDatabase();

  ///get_it 패키지를 통해 데이터를 주입한 후 앱 전체에 사용
  GetIt.I.registerSingleton<AppDatabase>(database);

  /// 데이터 사용 - GetIt.I<AppDatabase>();

  // final resp = await database.getSchedules();
  // print(resp);

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    ),
  );
}

/// intl 패키지 이용하여 한글 적용