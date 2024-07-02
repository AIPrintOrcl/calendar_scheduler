import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({
    super.key
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
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
                _SaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onStartTimeSaved(String? val){

  }
  String? onStartTimeValidate(String? val){

  }
  void onEndTimeSaved(String? val){

  }
  String? onEndTimeValidate(String? val){

  }

  void onContentSaved(String? val){

  }
  String? onContentValidate(String? val){

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
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: (){

            },
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
