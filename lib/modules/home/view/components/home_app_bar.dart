import 'package:flutter/material.dart';

import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';

class HomeAppbar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      extendedHeight: true,
      centerTitle: true,
      leading: CustomIconButton(
        icon: Icons.search_sharp,
        size: AppSize.s32,
        onPressed: () => NavigationService.push(context, Routes.searchScreen),
      ),
      title: Image.asset(
        L10n.isAr(context) ? AppImages.arabicLogo : AppImages.englishLogo,
        height: AppSize.s100.h,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppSize.s100.h);
}
