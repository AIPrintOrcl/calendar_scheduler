import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatelessWidget {
  const ScheduleBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 600,
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: '시작 시간',
                    ),
                  ), /* 시작시간 입력 */
                  SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      label: '마감 시간',
                    ),
                  ), /* 끝난시간 입력*/
                ],
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: CustomTextField(
                  label: '내용',
                  expand: true,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: categoryColors.map(
                      (e) => Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(
                          int.parse( /* 값을 16진수 integer로 변환 => 0xFFF44336 */
                            'FF$e', /* FF* 색의 투명도 나타냄. FF는 투명도0 */
                            radix: 16,
                          ),
                        ),
                        shape: BoxShape.circle,
                      ),
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                ).toList(),
              ),
              SizedBox(height: 8.0,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('저장'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
