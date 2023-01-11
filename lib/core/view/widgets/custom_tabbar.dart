import '../../extensions/num_extensions.dart';
import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class CustomTabBar extends StatelessWidget with PreferredSizeWidget {
  final String tab1Title;
  final String tab2Title;
  final TabController? tabController;

  const CustomTabBar({
    required this.tab1Title,
    required this.tab2Title,
    this.tabController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(color: AppColors.white, shape: StadiumBorder()),
      child: TabBar(
        controller: tabController,
        tabs: [Tab(text: tab1Title), Tab(text: tab2Title)],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight.h);
}
