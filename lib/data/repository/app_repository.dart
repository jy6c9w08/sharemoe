// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/data/model/app_info.dart';
import 'package:sharemoe/data/provider/api/app/app_rest_client.dart';

@lazySingleton
class AppRepository {
  final AppRestClient _appRestClient;

  AppRepository(this._appRestClient);

  Future<APPInfo> queryUpdateInfo(String version,String platform) {
    return _appRestClient
        .queryUpdateInfo(version,platform)
        .then((value) => value.data);
  }
}
