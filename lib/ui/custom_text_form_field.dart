
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reto_intercorp/utils/custom_color.dart';
import 'package:reto_intercorp/utils/custom_styles.dart';

class CustomTextFormField extends StatelessWidget with CustomStyles{
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final String hint;
  final String initialValue;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final ValueChanged<String> onFieldSubmitted;
  final FocusNode focusNode;


  CustomTextFormField({this.validator, this.onSaved, this.hint = "",
      this.initialValue, this.labelText = "", this.obscureText = false, this.keyboardType = TextInputType.text, this.inputFormatters, this.maxLength, this.controller, this.textInputAction, this.onFieldSubmitted, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(labelText, style: paragraphTextStyle.merge(TextStyle(color: CustomColor.primaryDarkColor)),),
        TextFormField(
          focusNode: focusNode,
          validator: validator,
          controller: controller,
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          textInputAction: textInputAction,
          initialValue: initialValue,
          obscureText: obscureText,
          maxLines: 1,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: titleTextStyle,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            hintText: hint,
            counter: new SizedBox(height: 0.0),
            contentPadding: const EdgeInsets.only(top: 0.0, bottom: 5.0),
            hintStyle: titleTextStyle.merge(TextStyle(color: CustomColor.textColorDisabled))
          ),
        ),
      ],
    );
  }
}
