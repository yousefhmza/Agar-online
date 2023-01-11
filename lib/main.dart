import 'package:agar_online/modules/block/cubits/block_cubit.dart';
import 'package:agar_online/modules/reports/cubits/reports_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/localization/cubit/l10n_cubit.dart';
import 'config/localization/l10n/l10n.dart';
import 'package:agar_online/modules/ad_type/cubit/ad_type_cubit.dart';
import 'package:agar_online/modules/auth/cubits/social_auth_cubit/social_auth_cubit.dart';
import 'package:agar_online/modules/chat/cubits/chat_cubit.dart';
import 'package:agar_online/modules/help_center/cubits/help_center_cubit.dart';
import 'config/routing/navigation_service.dart';
import 'config/routing/route_generator.dart';
import 'config/routing/routes.dart';
import 'config/theme/app_theme.dart';
import 'core/services/bloc_observer.dart';
import 'core/services/notifications/notification_fcm.dart';
import 'di_container.dart' as di;
import 'firebase_options.dart';
import 'modules/advertisements/cubits/add_ads_cubit/add_ads_cubit.dart';
import 'modules/advertisements/cubits/ads_cubit/ads_cubit.dart';
import 'modules/advertisements/cubits/edit_ad_cubit/edit_ad_cubit.dart';
import 'modules/auth/cubits/login_cubit/login_cubit.dart';
import 'modules/auth/cubits/signup_cubit/signup_cubit.dart';
import 'modules/categories/cubit/categories_cubit.dart';
import 'modules/favourites/cubits/favourites_cubit.dart';
import 'modules/home/cubits/home_cubit.dart';
import 'modules/layout/cubit/layout_cubit.dart';
import 'modules/profile/cubits/profile_cubit.dart';
import 'modules/regions/cubit/regions_cubit.dart';
import 'modules/search/cubit/search_cubit.dart';
import 'modules/splash/cubit/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  Bloc.observer = MyBlocObserver();
  NotificationsFCM();
  FirebaseMessaging.onBackgroundMessage(NotificationsFCM.firebaseMessagingBackgroundHandler);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<L10nCubit>()),
        BlocProvider(create: (_) => di.sl<SplashCubit>()),
        BlocProvider(create: (_) => di.sl<LoginCubit>()),
        BlocProvider(create: (_) => di.sl<SignupCubit>()),
        BlocProvider(create: (_) => di.sl<SocialAuthCubit>()),
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<LayoutCubit>()),
        BlocProvider(create: (_) => di.sl<AdsCubit>()),
        BlocProvider(create: (_) => di.sl<AddAdsCubit>()),
        BlocProvider(create: (_) => di.sl<EditAdCubit>()),
        BlocProvider(create: (_) => di.sl<CategoriesCubit>()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider(create: (_) => di.sl<SearchCubit>()),
        BlocProvider(create: (_) => di.sl<RegionsCubit>()),
        BlocProvider(create: (_) => di.sl<FavouritesCubit>()),
        BlocProvider(create: (_) => di.sl<HelpCenterCubit>()),
        BlocProvider(create: (_) => di.sl<AdTypesCubit>()),
        BlocProvider(create: (_) => di.sl<ChatCubit>()),
        BlocProvider(create: (_) => di.sl<ReportsCubit>()),
        BlocProvider(create: (_) => di.sl<BlockCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agar Online",
      debugShowCheckedModeBanner: false,
      theme: appTheme(context),
      initialRoute: Routes.splashScreen,
      navigatorKey: NavigationService.navigationKey,
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      localizationsDelegates: L10n.localizationDelegates,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: L10n.setFallbackLocale,
      locale: BlocProvider.of<L10nCubit>(context, listen: true).appLocale,
    );
  }
}
