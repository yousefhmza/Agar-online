import 'package:agar_online/modules/ad_type/cubit/ad_type_cubit.dart';
import 'package:agar_online/modules/ad_type/repository/ad_type_repository.dart';
import 'package:agar_online/modules/auth/cubits/social_auth_cubit/social_auth_cubit.dart';
import 'package:agar_online/modules/auth/repositories/social_auth_repository.dart';
import 'package:agar_online/modules/block/cubits/block_cubit.dart';
import 'package:agar_online/modules/block/repositories/block_repository.dart';
import 'package:agar_online/modules/chat/cubits/chat_cubit.dart';
import 'package:agar_online/modules/chat/repositories/chat_repository.dart';
import 'package:agar_online/modules/help_center/cubits/help_center_cubit.dart';
import 'package:agar_online/modules/help_center/repositories/help_center_repository.dart';
import 'package:agar_online/modules/reports/cubits/reports_cubit.dart';
import 'package:agar_online/modules/reports/repositories/reports_repository.dart';

import 'modules/favourites/cubits/favourites_cubit.dart';
import 'modules/favourites/repositories/favourites_repository.dart';

import 'modules/regions/cubit/regions_cubit.dart';
import 'modules/regions/repositories/regions_repository.dart';
import 'modules/search/cubit/search_cubit.dart';
import 'modules/search/repository/search_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/advertisements/repositories/ad_form_repository.dart';
import 'modules/advertisements/cubits/add_ads_cubit/add_ads_cubit.dart';
import 'modules/advertisements/cubits/edit_ad_cubit/edit_ad_cubit.dart';
import 'modules/profile/cubits/profile_cubit.dart';
import 'modules/advertisements/repositories/ads_repository.dart';
import 'modules/auth/cubits/login_cubit/login_cubit.dart';
import 'modules/auth/cubits/signup_cubit/signup_cubit.dart';
import 'modules/auth/repositories/login_repository.dart';
import 'modules/auth/repositories/signup_repository.dart';
import 'modules/categories/repositories/categories_repository.dart';
import 'modules/splash/repositories/splash_repository.dart';
import 'core/services/network/api_consumer.dart';
import 'core/services/network/network_info.dart';
import 'modules/advertisements/cubits/ads_cubit/ads_cubit.dart';
import 'modules/categories/cubit/categories_cubit.dart';
import 'config/localization/cubit/l10n_cubit.dart';
import 'core/services/local/cache_consumer.dart';
import 'modules/home/cubits/home_cubit.dart';
import 'modules/home/repositories/home_repository.dart';
import 'modules/profile/repositories/profile_repository.dart';
import 'modules/splash/cubit/splash_cubit.dart';
import 'modules/layout/cubit/layout_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // external
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<PrettyDioLogger>(
    () => PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true),
  );

  // core
  sl.registerLazySingleton<CacheConsumer>(() => CacheConsumer(sl<SharedPreferences>(), sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl<Connectivity>()));
  sl.registerLazySingleton<ApiConsumer>(() => ApiConsumer(sl<Dio>(), sl<CacheConsumer>(), sl<PrettyDioLogger>()));

  // repositories
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepository(sl<ApiConsumer>(), sl<NetworkInfo>(), sl<CacheConsumer>()),
  );
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepository(sl<ApiConsumer>(), sl<NetworkInfo>(), sl<CacheConsumer>()),
  );
  sl.registerLazySingleton<SignupRepository>(
    () => SignupRepository(sl<ApiConsumer>(), sl<NetworkInfo>(), sl<CacheConsumer>()),
  );
  sl.registerLazySingleton<SocialAuthRepository>(
    () => SocialAuthRepository(sl<ApiConsumer>(), sl<NetworkInfo>(), sl<CacheConsumer>()),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<CategoriesRepository>(() => CategoriesRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<AdsRepository>(() => AdsRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<AdFormRepository>(() => AdFormRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<RegionsRepository>(() => RegionsRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<SearchRepository>(() => SearchRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<FavouritesRepository>(() => FavouritesRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<HelpCenterRepository>(() => HelpCenterRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<AdTypesRepository>(() => AdTypesRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<ReportsRepository>(() => ReportsRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<BlockRepository>(() => BlockRepository(sl<ApiConsumer>(), sl<NetworkInfo>()));

  // cubits
  sl.registerFactory<L10nCubit>(() => L10nCubit(sl<CacheConsumer>())..initLocale());
  sl.registerFactory<SplashCubit>(() => SplashCubit(sl<SplashRepository>()));
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl<SignupRepository>()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl<LoginRepository>()));
  sl.registerFactory<SocialAuthCubit>(() => SocialAuthCubit(sl<SocialAuthRepository>()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>()));
  sl.registerFactory<CategoriesCubit>(() => CategoriesCubit(sl<CategoriesRepository>()));
  sl.registerFactory<AdsCubit>(() => AdsCubit(sl<AdsRepository>()));
  sl.registerFactory<AddAdsCubit>(() => AddAdsCubit(sl<AdFormRepository>()));
  sl.registerFactory<EditAdCubit>(() => EditAdCubit(sl<AdFormRepository>()));
  sl.registerFactory<RegionsCubit>(() => RegionsCubit(sl<RegionsRepository>()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepository>()));
  sl.registerFactory<SearchCubit>(() => SearchCubit(sl<SearchRepository>()));
  sl.registerFactory<FavouritesCubit>(() => FavouritesCubit(sl<FavouritesRepository>()));
  sl.registerFactory<HelpCenterCubit>(() => HelpCenterCubit(sl<HelpCenterRepository>()));
  sl.registerFactory<AdTypesCubit>(() => AdTypesCubit(sl<AdTypesRepository>()));
  sl.registerFactory<ChatCubit>(() => ChatCubit(sl<ChatRepository>()));
  sl.registerFactory<ReportsCubit>(() => ReportsCubit(sl<ReportsRepository>()));
  sl.registerFactory<BlockCubit>(() => BlockCubit(sl<BlockRepository>()));
  sl.registerFactory<LayoutCubit>(() => LayoutCubit());
}
