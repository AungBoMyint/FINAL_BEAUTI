import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    Key? key,
    required this.controller,
    this.label,
    required this.isUnderlineBorder,
    this.textFieldPaddingLeft,
    this.stringKey,
    this.height,
    this.validator,
    this.isLabel = true,
    this.padding = 25,
    this.labelText,
    this.leftPadding,
    this.rightPadding,
    this.error,
    this.maxLength,
    this.autoExpanded = false,
    this.keyboaType,
    this.maxLines,
    this.topPaddig,
    this.textFieldPaddingTop,
    this.textFieldPaddingBottom,
    this.textFieldPaddingRight,
  }) : super(key: key);

  final TextEditingController controller;
  final String? label;
  final bool isUnderlineBorder;
  final double? textFieldPaddingLeft;
  final double? height;
  final bool isLabel;
  final double padding;
  final double? leftPadding;
  final double? rightPadding;
  final String? labelText;
  final String? Function(String?)? validator;
  final String? error;
  final String? stringKey;
  final bool autoExpanded;
  final int? maxLines;
  final TextInputType? keyboaType;
  final double? topPaddig;
  final double? textFieldPaddingTop;
  final double? textFieldPaddingBottom;
  final double? textFieldPaddingRight;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: leftPadding ?? 0,
          right: rightPadding ?? 0,
          top: topPaddig ?? 10),
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboaType,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            counter: null,
            counterText: "",
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: isUnderlineBorder
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(
                    color: Colors.black,
                  ))
                : const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
            focusedBorder: isUnderlineBorder
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(
                    color: Colors.black,
                  ))
                : const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
