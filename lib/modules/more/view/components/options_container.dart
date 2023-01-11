import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../models/option_model.dart';
import '../widgets/option_item.dart';

class OptionsContainer extends StatelessWidget {
  final List<Option> options;
  final bool isAuthed;

  const OptionsContainer(this.options, {required this.isAuthed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSize.s4.h,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s16.r),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.all(AppPadding.p16.w),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => OptionItem(options[index]),
      ),
    );
  }
}
