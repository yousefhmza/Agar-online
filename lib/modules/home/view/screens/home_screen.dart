import 'package:flutter/material.dart';

import '../../../../core/view/app_views.dart';
import '../../../advertisements/view/components/featured_ads.dart';
import '../components/home_app_bar.dart';
import '../components/home_main_section.dart';
import '../../../../config/localization/l10n/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeAppbar(),
        CustomTabBar(
          tab1Title: L10n.tr(context).home,
          tab2Title: L10n.tr(context).featuredAds,
          tabController: tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              HomeMainSection(tabController: tabController),
              const FeaturedAds(),
            ],
          ),
        ),
      ],
    );
  }
}
