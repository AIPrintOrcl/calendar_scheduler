import 'package:flutter/material.dart';
import 'package:calendar_scheduler/const/color.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool expand;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField({
    required this.label,
    required this.onSaved,
    required this.validator,
    this.expand = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        if(!expand)
          renderTextFormField(),
        if(expand) /* 내용 텍스트 필드일 경우 */
          Expanded(
            child: renderTextFormField(),
          ),
      ],
    );
  }

  renderTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[100],
      ),
      /// 저장 했을때 로직
      onSaved: onSaved,
      /// 검증 할 때 로직
      validator: validator,
      /* 내용 텍스트 필드일 경우 줄 제한 없이 */
      maxLines: expand ? null : 1,
      minLines: expand ? null : 1,
      expands: expand,
      cursorColor: Colors.grey,
    );
  }
}

/// 내용 텍스트 필드 최대 공간으로 만들기
/// 1. 해당 TextField가 Expanded여야 한다.
/// 2. renderTextFormField
///       maxLines: expand ? null : 1,
///       minLines: expand ? null : 1, max/minLines 둘 중 하나가 null이여야 한다.
///       expands: expand, /// expands:가 true여야 한다.