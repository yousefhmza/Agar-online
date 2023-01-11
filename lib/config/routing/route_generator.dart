import 'package:flutter/material.dart';

import '../../modules/advertisements/view/screens/latest_ads_screen.dart';
import '../../modules/advertisements/view/screens/my_ads_screen.dart';
import '../../modules/advertisements/view/screens/edit_ad_screen.dart';
import '../../modules/categories/view/screens/all_categories_screen.dart';
import '../../modules/categories/view/screens/sub_sub_category_screen.dart';
import '../../modules/chat/view/screens/chat_screen.dart';
import '../../modules/favourites/view/screens/favourites_screen.dart';
import '../../modules/help_center/view/screens/help_center_screen.dart';
import '../../modules/profile/view/screens/edit_profile_screen.dart';
import '../../modules/search/view/screens/search_screen.dart';
import '../../modules/advertisements/view/screens/ad_details_screen.dart';
import '../../modules/auth/view/screens/login_screen.dart';
import '../../modules/auth/view/screens/signup_screen.dart';
import '../../modules/layout/view/screens/layout_screen.dart';
import '../../core/view/screens/undefined_route_screen.dart';
import 'platform_page_route.dart';
import 'routes.dart';
import '../../modules/splash/view/screens/splash_screen.dart';
import '../../modules/categories/view/screens/category_screen.dart';

class RouteGenerator {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return platformPageRoute(const SplashScreen());
      case Routes.layoutScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return platformPageRoute(LayoutScreen(fromSignup: arguments["from_signup"]));
      case Routes.loginScreen:
        return platformPageRoute(LoginScreen());
      case Routes.signupScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return platformPageRoute(SignupScreen(reachedFromLogin: arguments["from_login"]));
      case Routes.adDetailsScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return platformPageRoute(AdDetailsScreen(id: arguments["id"]));
      case Routes.categoryScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return platformPageRoute(CategoryScreen(category: arguments["category"]));
      case Routes.helpCenterScreen:
        return platformPageRoute(HelpCenterScreen());
      case Routes.myAdsScreen:
        return platformPageRoute(const MyAdsScreen());
      case Routes.latestAdsScreen:
        return platformPageRoute(const LatestAdsScreen());
      case Routes.editAdScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return platformPageRoute(EditAdScreen(arguments["ad"]));
      case Routes.favouritesScreen:
        return platformPageRoute(const FavouritesScreen());
      case Routes.chatScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return platformPageRoute(
          ChatScreen(
            otherUserId: arguments["other_user_id"],
            otherUserImage: arguments["other_user_image"],
            otherUserName: arguments["other_user_name"],
            adId: arguments["ad_id"],
          ),
        );
      case Routes.editProfileScreen:
        return platformPageRoute(EditProfileScreen());
      case Routes.searchScreen:
        return platformPageRoute(const SearchScreen());
      case Routes.allCategoriesScreen:
        return platformPageRoute(const AllCategoriesScreen());
      case Routes.subSubCategoryScreen:
        final arguments = settings.arguments as Map<String, dynamic>;
        return platformPageRoute(SubSubCategoryScreen(
          categoryId: arguments["category_id"],
          subCategoryName: arguments["sub_category_name"],
          subSubCategory: arguments["sub_sub_category"],
          allSubSubCategories: arguments["all_sub_sub_categories"],
        ));
      default:
        return platformPageRoute(const UndefinedRouteScreen());
    }
  }
}
