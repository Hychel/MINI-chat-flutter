import 'app_strings.dart';
import 'package:flutter/material.dart';


class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailErrorRequired;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return AppStrings.emailErrorInvalid;
    }

    if (value.trim().length < 5) {
      return AppStrings.emailErrorShort;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordErrorRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordErrorShort;
    }

    return null;
  }

  static String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nicknameErrorRequired;
    }

    final cleanedValue = value.trim();

    if (cleanedValue.length < 2) {
      return AppStrings.nicknameErrorShort;
    }

    if (cleanedValue.length > 20) {
      return AppStrings.nicknameErrorLong;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(cleanedValue)) {
      return AppStrings.nicknameErrorChars;
    }

    if (cleanedValue.contains(' ')) {
      return AppStrings.nicknameErrorSpaces;
    }

    return null;
  }

  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.messageErrorEmpty;
    }

    final cleanedValue = value.trim();

    if (cleanedValue.length < 1) {
      return AppStrings.messageErrorShort;
    }

    if (cleanedValue.length > 500) {
      return AppStrings.messageErrorLong;
    }

    return null;
  }

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredFieldError;
    }
    return null;
  }

  static bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }
}
