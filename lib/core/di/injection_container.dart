import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../connectivity/connectivity_cubit.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/applied_careers_store.dart';
import '../services/fcm_token_sync_service.dart';
import '../services/push_notification_service.dart';
import '../session/auth_session.dart';
import '../storage/secure_storage_service.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/bloc/otp_bloc.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';

import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

import '../../features/deals/data/datasources/deals_remote_data_source.dart';
import '../../features/deals/data/repositories/deals_repository_impl.dart';
import '../../features/deals/domain/repositories/deals_repository.dart';
import '../../features/deals/domain/usecases/get_categories_usecase.dart';
import '../../features/deals/domain/usecases/get_products_usecase.dart';
import '../../features/deals/presentation/bloc/deals_bloc.dart';

import '../../features/coupons/data/datasources/coupons_remote_data_source.dart';
import '../../features/coupons/data/repositories/coupons_repository_impl.dart';
import '../../features/coupons/domain/repositories/coupons_repository.dart';
import '../../features/coupons/domain/usecases/clip_coupon_usecase.dart';
import '../../features/coupons/domain/usecases/get_coupons_usecase.dart';
import '../../features/coupons/presentation/cubit/coupons_cubit.dart';

import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/delete_me_usecase.dart';
import '../../features/profile/domain/usecases/get_me_usecase.dart';
import '../../features/profile/domain/usecases/update_me_usecase.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

import '../../features/socials/data/datasources/socials_remote_data_source.dart';
import '../../features/socials/data/repositories/socials_repository_impl.dart';
import '../../features/socials/domain/repositories/socials_repository.dart';
import '../../features/socials/domain/usecases/get_socials_usecase.dart';
import '../../features/socials/presentation/cubit/socials_cubit.dart';

import '../../features/qr/data/datasources/qr_remote_data_source.dart';
import '../../features/qr/data/repositories/qr_repository_impl.dart';
import '../../features/qr/domain/repositories/qr_repository.dart';
import '../../features/qr/domain/usecases/get_qrs_usecase.dart';
import '../../features/qr/presentation/cubit/qr_cubit.dart';

import '../../features/weekly_ads/data/datasources/weekly_ads_remote_data_source.dart';
import '../../features/weekly_ads/data/repositories/weekly_ads_repository_impl.dart';
import '../../features/weekly_ads/domain/repositories/weekly_ads_repository.dart';
import '../../features/weekly_ads/domain/usecases/get_weekly_ads_usecase.dart';
import '../../features/weekly_ads/presentation/cubit/weekly_ads_cubit.dart';

import '../../features/locations/data/datasources/locations_remote_data_source.dart';
import '../../features/locations/data/repositories/locations_repository_impl.dart';
import '../../features/locations/domain/repositories/locations_repository.dart';
import '../../features/locations/domain/usecases/get_locations_usecase.dart';
import '../../features/locations/presentation/cubit/locations_cubit.dart';

import '../../features/legal/data/datasources/legal_document_remote_data_source.dart';
import '../../features/legal/data/repositories/legal_document_repository_impl.dart';
import '../../features/legal/domain/repositories/legal_document_repository.dart';
import '../../features/legal/domain/usecases/get_legal_document_usecase.dart';
import '../../features/legal/presentation/cubit/legal_document_cubit.dart';

import '../../features/careers/data/datasources/careers_remote_data_source.dart';
import '../../features/careers/data/repositories/careers_repository_impl.dart';
import '../../features/careers/domain/repositories/careers_repository.dart';
import '../../features/careers/domain/usecases/apply_to_career_usecase.dart';
import '../../features/careers/domain/usecases/get_careers_usecase.dart';
import '../../features/careers/presentation/bloc/career_apply_bloc.dart';
import '../../features/careers/presentation/cubit/careers_cubit.dart';

import '../../features/rewards/data/datasources/rewards_remote_data_source.dart';
import '../../features/rewards/data/repositories/rewards_repository_impl.dart';
import '../../features/rewards/domain/repositories/rewards_repository.dart';
import '../../features/rewards/domain/usecases/get_rewards_usecase.dart';
import '../../features/rewards/domain/usecases/redeem_reward_usecase.dart';
import '../../features/rewards/presentation/cubit/rewards_cubit.dart';

import '../../features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

/// Manual composition root. Registered in dependency order: core singletons
/// first, then each feature's data -> domain -> presentation layer.
Future<void> initDependencies() async {
  // ---- Core ----
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => SecureStorageService(sl()));
  sl.registerLazySingleton(() => AuthSession(sl()));
  sl.registerLazySingleton(() => AppliedCareersStore(sl(), sl()));
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ConnectivityCubit(sl()));
  sl.registerLazySingleton(() => PushNotificationService());

  sl.registerLazySingleton(() => AuthInterceptor(sl()));
  sl.registerLazySingleton<Dio>(() => DioClient.create(sl()));

  // ---- Auth ----
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl(), sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => OtpBloc(sl(), sl()));

  // ---- Home ----
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetHomeUseCase(sl()));
  sl.registerFactory(() => HomeCubit(sl()));

  // ---- Deals ----
  sl.registerLazySingleton<DealsRemoteDataSource>(() => DealsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<DealsRepository>(() => DealsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerFactory(() => DealsBloc(sl(), sl()));

  // ---- Coupons ----
  sl.registerLazySingleton<CouponsRemoteDataSource>(() => CouponsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CouponsRepository>(() => CouponsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetCouponsUseCase(sl()));
  sl.registerLazySingleton(() => ClipCouponUseCase(sl()));
  sl.registerFactory(() => CouponsCubit(sl(), sl()));

  // ---- Profile ----
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl(), sl(), sl()));
  sl.registerLazySingleton(() => GetMeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMeUseCase(sl()));
  sl.registerFactory(() => ProfileCubit(sl(), sl(), sl(), sl()));

  sl.registerLazySingleton(() => FcmTokenSyncService(sl(), sl(), sl()));

  // ---- Socials ----
  sl.registerLazySingleton<SocialsRemoteDataSource>(() => SocialsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<SocialsRepository>(() => SocialsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetSocialsUseCase(sl()));
  sl.registerFactory(() => SocialsCubit(sl()));

  // ---- QR ----
  sl.registerLazySingleton<QrRemoteDataSource>(() => QrRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<QrRepository>(() => QrRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetQrsUseCase(sl()));
  sl.registerFactory(() => QrCubit(sl()));

  // ---- Weekly Ads ----
  sl.registerLazySingleton<WeeklyAdsRemoteDataSource>(() => WeeklyAdsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<WeeklyAdsRepository>(() => WeeklyAdsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetWeeklyAdsUseCase(sl()));
  sl.registerFactory(() => WeeklyAdsCubit(sl()));

  // ---- Locations ----
  sl.registerLazySingleton<LocationsRemoteDataSource>(() => LocationsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<LocationsRepository>(() => LocationsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetLocationsUseCase(sl()));
  sl.registerFactory(() => LocationsCubit(sl()));

  // ---- Legal ----
  sl.registerLazySingleton<LegalDocumentRemoteDataSource>(() => LegalDocumentRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<LegalDocumentRepository>(() => LegalDocumentRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetLegalDocumentUseCase(sl()));
  sl.registerFactory(() => LegalDocumentCubit(sl()));

  // ---- Careers ----
  sl.registerLazySingleton<CareersRemoteDataSource>(() => CareersRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CareersRepository>(() => CareersRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetCareersUseCase(sl()));
  sl.registerLazySingleton(() => ApplyToCareerUseCase(sl()));
  sl.registerFactory(() => CareersCubit(sl(), sl()));
  sl.registerFactory(() => CareerApplyBloc(sl(), sl()));

  // ---- Rewards ----
  sl.registerLazySingleton<RewardsRemoteDataSource>(() => RewardsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<RewardsRepository>(() => RewardsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetRewardsUseCase(sl()));
  sl.registerLazySingleton(() => RedeemRewardUseCase(sl()));
  sl.registerFactory(() => RewardsCubit(sl(), sl(), sl()));

  // ---- Splash ----
  sl.registerFactory(() => SplashCubit(sl(), sl(), sl()));

  await sl<AuthSession>().restore();
}
