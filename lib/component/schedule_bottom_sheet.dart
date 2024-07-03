import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDay;

  const ScheduleBottomSheet({
    required this.selectedDay,
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

  String selectedColor = categoryColors.first;

  @override
  Widget build(BuildContext context) {
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
                ),
                SizedBox(height: 8.0),
                _Content(
                  onSaved: onContentSaved,
                  onValidate: onContentValidate,
                ),
                SizedBox(height: 8.0),
                _Categories(
                  selectedColor: selectedColor,
                  onTap: (String color) {
                    setState(() {
                      selectedColor = color;
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
  void onSavePressed() {
    final isValid = formKey.currentState!.validate();

    if(isValid){
      formKey.currentState!.save();

      // final schedule = Schedule(
      //   id: 999,
      //   startTime: startTime!,
      //   endTime: endTime!,
      //   content: content!,
      //   date: widget.selectedDay,
      //   color: selectedColor,
      //   createdAt: DateTime.now().toUtc(),
      // );
      //
      // Navigator.of(context).pop(
      //     schedule,
      // );
    }

  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;

  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.onStartValidate,
    required this.onEndValidate,
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
          ),
        ), /* 시작시간 입력 */
        SizedBox(width: 16.0),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            onSaved: onEndSaved,
            validator: onEndValidate,
          ),
        ), /* 끝난시간 입력*/
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> onValidate;

  const _Content({
    required this.onSaved,
    required this.onValidate,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        expand: true,
        onSaved: onSaved,
        validator: onValidate,
      ),
    );
  }
}

/* onTap을 통해 color 값 가져오기 위한 패턴*/
typedef OnColorSelected = void Function(String color);

class _Categories extends StatelessWidget {
  final String selectedColor;
  final OnColorSelected onTap;

  const _Categories({
    required this.selectedColor,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: categoryColors.map(
            (e) => Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              onTap(e);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(
                  int.parse( /* 값을 16진수 integer로 변환 => 0xFFF44336 */
                    'FF$e', /* FF* 색의 투명도 나타냄. FF는 투명도0 */
                    radix: 16,
                  ),
                ),
                border: e == selectedColor
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
