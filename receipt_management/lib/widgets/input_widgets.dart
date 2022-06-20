import 'package:flutter/material.dart';
import 'package:receipt_management/validators.dart';

Widget inputField(
  TextEditingController inputController,
  String validatorType, {
  TextEditingController? password,
  inputLabel,
  inputValue,
  Icon? fieldIcon,
  bool isObscure = true,
}) {
  return TextFormField(
    keyboardType:
        validatorType == 'emailValidator' ? TextInputType.emailAddress : null,
    controller: inputController,
    obscureText: isObscure,
    decoration: InputDecoration(
      prefixIcon: fieldIcon,
      hintText: inputValue,
      labelText: inputLabel,
      enabledBorder: defaultInputBorder(),
      focusedBorder: onFocusInputBorder(),
    ),
    validator: (String? value) => validatorType == 'nameValidator'
        ? nameValidator(inputController.text)
        : validatorType == 'emailValidator'
            ? emailValidator(inputController.text)
            : validatorType == 'passwordValidator'
                ? passwordValidator(inputController.text)
                : validatorType == 'rePasswordValidator'
                    ? rePasswordValidator(inputController.text, password!.text)
                    : null,
  );
}

Widget profileOutput({
  inputLabel,
  inputValue,
  Icon? fieldIcon,
  bool isObscure = true,
  bool readOnly = true,
}) {
  return TextFormField(
    enabled: readOnly,
    obscureText: true,
    decoration: InputDecoration(
      prefixIcon: fieldIcon,
      hintText: inputValue,
      labelText: inputLabel,
      enabledBorder: defaultInputBorder(),
      focusedBorder: onFocusInputBorder(),
    ),
  );
}

Widget inputFieldEdit(
  TextEditingController inputController,
  String validatorType, {
  TextEditingController? password,
  inputLabel,
  inputValue,
  Icon? fieldIcon,
  bool isObscure = true,
}) {
  return TextFormField(
    keyboardType:
        validatorType == 'emailValidator' ? TextInputType.emailAddress : null,
    controller: inputController,
    obscureText: isObscure,
    decoration: InputDecoration(
      prefixIcon: fieldIcon,
      hintText: inputValue,
      labelText: inputLabel,
      enabledBorder: defaultInputBorder(),
      focusedBorder: onFocusInputBorder(),
    ),
    validator: (String? value) => validatorType == 'nameValidator'
        ? nameValidator(inputController.text)
        : validatorType == 'emailValidator'
            ? emailValidator(inputController.text)
            : validatorType == 'passwordValidator'
                ? passwordEditValidator(inputController.text)
                : validatorType == 'rePasswordValidator'
                    ? rePasswordEditValidator(
                        inputController.text, password!.text)
                    : null,
  );
}

TextStyle labelTextStyle({double fontSize = 12}) {
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: fontSize,
  );
}

OutlineInputBorder defaultInputBorder() {
  //return type is OutlineInputBorder
  return const OutlineInputBorder(
      //Outline border type for TextField
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1,
      ));
}

OutlineInputBorder onFocusInputBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      gapPadding: 10,
      borderSide: BorderSide(
        color: Colors.black,
        width: 1,
      ));
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class AllowFocusNode extends FocusNode {
  @override
  bool get hasFocus => true;
}
