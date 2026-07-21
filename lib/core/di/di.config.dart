// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter/services.dart' as _i281;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/api/api_client.dart' as _i681;
import '../../data/datasource/contract/auth_remote_datasource.dart' as _i912;
import '../../data/datasource/implementation/auth_remote_datasource_impl.dart'
    as _i836;
import '../../data/repository/auth_repository_impl.dart' as _i581;
import '../../domain/repository/auth_repository.dart' as _i614;
import '../../domain/use_case/auth/forgot_password_use_case.dart' as _i120;
import '../../domain/use_case/auth/reset_password_use_case.dart' as _i603;
import '../../domain/use_case/auth/verify_reset_code_use_case.dart' as _i759;
import '../../presentation/auth/cubit/auth_cubit.dart' as _i1063;
import '../network/auth_interceptor.dart' as _i908;
import '../widgets/app_config_prvider.dart' as _i24;
import '../widgets/app_router.dart' as _i389;
import 'asset_bundle_module.dart' as _i44;
import 'network_module.dart' as _i567;
import 'storage_module.dart' as _i371;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    final assetBundleModule = _$AssetBundleModule();
    final networkModule = _$NetworkModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => storageModule.getSharedPreferences(),
      preResolve: true,
    );
    gh.singleton<_i281.AssetBundle>(
      () => assetBundleModule.provideAssetBundle(),
    );
    gh.singleton<_i389.AppRouter>(() => _i389.AppRouter());
    gh.factory<_i908.AuthInterceptor>(
      () => _i908.AuthInterceptor(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i361.Dio>(
      () => networkModule.provideDio(gh<_i908.AuthInterceptor>()),
    );
    gh.lazySingleton<_i24.AppConfigProvider>(
      () => _i24.AppConfigProvider(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i681.ApiClient>(() => _i681.ApiClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i912.AuthRemoteDataSource>(
      () => _i836.AuthRemoteDataSourceImpl(gh<_i681.ApiClient>()),
    );
    gh.lazySingleton<_i614.AuthRepository>(
      () => _i581.AuthRepositoryImpl(gh<_i912.AuthRemoteDataSource>()),
    );
    gh.factory<_i120.ForgotPasswordUseCase>(
      () => _i120.ForgotPasswordUseCase(gh<_i614.AuthRepository>()),
    );
    gh.factory<_i603.ResetPasswordUseCase>(
      () => _i603.ResetPasswordUseCase(gh<_i614.AuthRepository>()),
    );
    gh.factory<_i759.VerifyResetCodeUseCase>(
      () => _i759.VerifyResetCodeUseCase(gh<_i614.AuthRepository>()),
    );
    gh.factory<_i1063.AuthCubit>(
      () => _i1063.AuthCubit(
        gh<_i120.ForgotPasswordUseCase>(),
        gh<_i759.VerifyResetCodeUseCase>(),
        gh<_i603.ResetPasswordUseCase>(),
      ),
    );
    return this;
  }
}

class _$StorageModule extends _i371.StorageModule {}

class _$AssetBundleModule extends _i44.AssetBundleModule {}

class _$NetworkModule extends _i567.NetworkModule {}
