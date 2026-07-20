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
    return this;
  }
}

class _$StorageModule extends _i371.StorageModule {}

class _$AssetBundleModule extends _i44.AssetBundleModule {}

class _$NetworkModule extends _i567.NetworkModule {}
