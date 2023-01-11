import '../../../config/localization/l10n/l10n.dart';

import '../../extensions/num_extensions.dart';
import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? initialValue;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final AutovalidateMode? autoValidateMode;
  final TextInputAction? textInputAction;

  const CustomTextField({
    required this.hintText,
    this.prefix,
    this.suffix,
    this.validator,
    this.readOnly = false,
    this.obscureText = false,
    this.keyBoardType,
    this.controller,
    this.formatters,
    this.onChanged,
    this.onTap,
    this.onSaved,
    this.onSubmitted,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.initialValue,
    this.autoValidateMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autoValidateMode,
      cursorColor: AppColors.primaryRed,
      textCapitalization: TextCapitalization.sentences,
      obscureText: obscureText,
      readOnly: readOnly,
      validator: validator,
      controller: controller,
      inputFormatters: formatters,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      onSaved: onSaved,
      onFieldSubmitted: onSubmitted,
      initialValue: initialValue,
      keyboardType: keyBoardType,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      textInputAction: textInputAction,
      style: TextStyle(
        color: AppColors.black,
        fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontSize: FontSize.s16.sp,
        fontWeight: FontWeightManager.regular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefix != null ? Padding(padding: EdgeInsets.all(AppPadding.p8.w), child: prefix) : null,
        prefixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        suffixIcon: suffix != null ? Padding(padding: EdgeInsets.all(AppPadding.p8.w), child: suffix) : null,
        suffixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
      ),
    );
  }
}
