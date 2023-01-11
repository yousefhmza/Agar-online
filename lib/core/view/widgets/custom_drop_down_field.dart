import '../../resources/app_resources.dart';
import '../app_views.dart';

import '../../extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class CustomDropDownField<T> extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final void Function()? onTap;
  final String? Function(T?)? validator;
  final Widget? prefix;
  final Widget? suffix;
  final T? value;
  final TextInputType? keyBoardType;
  final AutovalidateMode? autoValidateMode;
  final double iconSize;
  final bool hasLoadingSuffix;

  const CustomDropDownField({
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.items,
    this.prefix,
    this.suffix,
    this.validator,
    this.keyBoardType,
    this.value,
    this.autoValidateMode,
    this.iconSize = AppSize.s24,
    this.hasLoadingSuffix = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: items,
      onChanged: onChanged,
      validator: validator,
      value: value,
      onTap: onTap,
      iconSize: iconSize.sp,
      elevation: AppSize.s0.toInt(),
      hint: CustomText(hintText, color: AppColors.hintText),
      isDense: true,
      isExpanded: true,
      autovalidateMode: autoValidateMode,
      decoration: InputDecoration(
        prefixIcon: prefix != null ? Padding(padding: EdgeInsets.all(AppPadding.p8.w), child: prefix) : null,
        prefixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        suffixIcon: hasLoadingSuffix
            ? Padding(
                padding: EdgeInsets.all(AppPadding.p16.w),
                child: SizedBox(
                  width: AppSize.s16.w,
                  height: AppSize.s16.w,
                  child: CircularProgressIndicator(strokeWidth: AppSize.s2.w),
                ),
              )
            : suffix != null
                ? Padding(padding: EdgeInsets.all(AppPadding.p16.w), child: suffix)
                : null,
        suffixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
      ),
    );
  }
}
