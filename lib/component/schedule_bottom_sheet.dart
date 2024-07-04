import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart' hide Column; /* flutter의 Column과 겹친다. drift의 Column을 숨긴다. */
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDay;
  final int? id;

  const ScheduleBottomSheet({
    required this.selectedDay,
    this.id,
    super.key
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey(); /* 전체 프로젝트에서 단 하나의 자동 생성되는 키값. Form의 상태값을 입력되어있다. */

  int? startTime;
  int? endTime;
  String? content;

  int? selectedColorId;

  /// State가 처음 생성되었을 때 한번만 실행
  @override
  void initState() {
    super.initState();

    initCategory();
  }

  /// State가 처음 생성되었을 때 최초로 한번만 id가 null이 아닐 때 선택한 스케쥴의 카테고리 정보를 selectedColor에 입력한다.
  initCategory() async {
    if(widget.id != null){
      final resp = await GetIt.I<AppDatabase>().getScheduleById(widget.id!);

      setState(() {
        selectedColorId = resp.category.id;
      });
    }else{ /* 스케쥴 추가 시 첫 번째로 카테고리 지정한다. */
      final resp = await GetIt.I<AppDatabase>().getCategories();

      setState(() {
        selectedColorId = resp.first.id;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if(selectedColorId == null) { /* selectedColorId가 null일 경우 예외처리 */
      return Container();
    }

    return FutureBuilder(
      /// 스케쥴 선택X 추가 버튼 => 스케쥴 추가. 스케쥴 선택O 추가 버튼 => 스케쥴 수정
      future: widget.id == null
        ? null
        : GetIt.I<AppDatabase>().getScheduleById(widget.id!), /* id가 null 일 경우 스케쥴 추가 기능. id가 null이 아닐 경우 스케쥴 수정 기능. */
      builder: (context, snapshot) {
        /// 데이터가 null 값이 아닐 경우 + 딜레이로 인해 데이터가 들어오지 않는 상태일 경우 + 데이터가 없는 경우(최초) => 로딩 중 표시
        if(widget.id != null &&
            snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        /// future: 으로 통한 스케쥴 정보 입력
        final data = snapshot.data?.schedule;

        return Container(
          color: Colors.white,
          height: 600,
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _Time(
                      onStartSaved: onStartTimeSaved,
                      onStartValidate: onStartTimeValidate,
                      onEndSaved: onEndTimeSaved,
                      onEndValidate: onEndTimeValidate,
                      startTimeInitValue: data?.startTime.toString(),
                      endTimeInitValue: data?.endTime.toString(),
                    ),
                    SizedBox(height: 8.0),
                    _Content(
                      onSaved: onContentSaved,
                      onValidate: onContentValidate,
                      contentInitValue: data?.content,
                    ),
                    SizedBox(height: 8.0),
                    _Categories(
                      selectedColor: selectedColorId!,
                      onTap: (int color) {
                        setState(() {
                          selectedColorId = color;
                        });
                      },
                    ),
                    SizedBox(height: 8.0,),
                    _SaveButton(
                      onPressed: onSavePressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void onStartTimeSaved(String? val){
    if(val == null) return;

    startTime = int.parse(val);
  }
  String? onStartTimeValidate(String? val){
    if(val == null) {
      return '값을 입력 해주세요.';
    }

    if(int.tryParse(val) == null){
      return '숫자를 입력 해주세요.';
    }

    final time = int.parse(val);

    if(time < 0 || time > 24) {
      return '0~24 숫자를 입력 해주세요.';
    }

    return null;
  }
  void onEndTimeSaved(String? val){
    if(val == null) return;

    endTime = int.parse(val);
  }
  String? onEndTimeValidate(String? val){
    if(val == null) {
      return '값을 입력 해주세요.';
    }

    if(int.tryParse(val) == null){
      return '숫자를 입력 해주세요.';
    }

    final time = int.parse(val);

    if(time < 0 || time > 24) {
      return '0~24 숫자를 입력 해주세요.';
    }

    return null;
  }

  void onContentSaved(String? val){
    if(val == null) return;

    content = val;
  }
  String? onContentValidate(String? val){
    if(val == null) {
      return '내용을 입력 해주세요.';
    }
    if(val.length < 3) {
      return '3글자이상 입력해주세요.';
    }

    return null;
  }

  /// 2. 새로운 스케쥴 추가
  void onSavePressed() async {
    final isValid = formKey.currentState!.validate();

    if(isValid){
      formKey.currentState!.save();

      /// 생성된 앱 데이터베이스 이용.
      final database = GetIt.I<AppDatabase>();

      if(widget.id == null) {
        await database.createSchedule( /* 추가 버튼 클릭하여 시트를 오픈 => id=null */
          ScheduleTableCompanion(
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
            date: Value(widget.selectedDay),
          ),
        );
      } else if(widget.id != null) {
        await database.updateScheduleById( /* 스케쥴 클릭하여 시트를 오픈 => id!=null */
          widget.id!,
          ScheduleTableCompanion(
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
            date: Value(widget.selectedDay),
          ),
        );
      }


      Navigator.of(context).pop();
    }

  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;
  final String? startTimeInitValue;
  final String? endTimeInitValue;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.onStartValidate,
    required this.onEndValidate,
    this.startTimeInitValue,
    this.endTimeInitValue,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            onSaved: onStartSaved,
            validator: onStartValidate,
            initialValue: startTimeInitValue,
          ),
        ), /* 시작시간 입력 */
        SizedBox(width: 16.0),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            onSaved: onEndSaved,
            validator: onEndValidate,
            initialValue: endTimeInitValue,
          ),
        ), /* 끝난시간 입력*/
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> onValidate;
  final String? contentInitValue;

  const _Content({
    required this.onSaved,
    required this.onValidate,
    this.contentInitValue,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        expand: true,
        onSaved: onSaved,
        validator: onValidate,
        initialValue: contentInitValue,
      ),
    );
  }
}

/* onTap을 통해 color 값 가져오기 위한 패턴*/
typedef OnColorSelected = void Function(int color);

class _Categories extends StatelessWidget {
  final int selectedColor;
  final OnColorSelected onTap;

  const _Categories({
    required this.selectedColor,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<AppDatabase>().getCategories(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Container();
        }

        return Row(
          children: snapshot.data!.map(
                (e) => Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  onTap(e.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse( /* 값을 16진수 integer로 변환 => 0xFFF44336 */
                        'FF${e.color}', /* FF* 색의 투명도 나타냄. FF는 투명도0 */
                        radix: 16,
                      ),
                    ),
                    border: e.id == selectedColor
                        ? Border.all(
                      color: Colors.black,
                      width: 4.0,
                    ) : null,
                    shape: BoxShape.circle,
                  ),
                  width: 32.0,
                  height: 32.0,
                ),
              ),
            ),
          ).toList(),
        );
      }
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}
