import '../../config/localization/l10n/l10n.dart';
import '../../config/routing/navigation_service.dart';
import '../extensions/non_null_extensions.dart';

class Validators {
  static String? mobileNumberValidator(String? input) {
    return !RegExp(r"^01(0|1|2|5)[0-9]{8}$").hasMatch(input.orEmpty)
        ? L10n.tr(NavigationService.navigationKey.currentContext!).mobileValidator
        : null;
  }

  static String? passwordValidator(String? input) {
    return input.orEmpty.length < 8 ? L10n.tr(NavigationService.navigationKey.currentContext!).passwordValidator : null;
  }

  static String? confirmPasswordValidator(String? input, String password) {
    return input.orEmpty != password
        ? L10n.tr(NavigationService.navigationKey.currentContext!).confirmPasswordValidator
        : null;
  }

  static String? nameValidator(String? input) {
    return input.orEmpty.isEmpty ? L10n.tr(NavigationService.navigationKey.currentContext!).nameValidator : null;
  }

  static String? emailValidator(String? input) {
    return !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input.orEmpty)
        ? L10n.tr(NavigationService.navigationKey.currentContext!).emailValidator
        : null;
  }

  static String? notEmptyValidator(String? input) {
    return input.orEmpty.isEmpty ? L10n.tr(NavigationService.navigationKey.currentContext!).requiredField : null;
  }

  static String? notEmptyDropDownValidator(dynamic input) {
    return input == null ? L10n.tr(NavigationService.navigationKey.currentContext!).requiredField : null;
  }
}
