// Package imports:
import 'package:injectable/injectable.dart';
import 'package:sharemoe/data/model/app_info.dart';

// Project imports:
import 'package:sharemoe/data/model/server_address.dart';
import 'package:sharemoe/data/provider/api/app/app_rest_client.dart';
import 'package:sharemoe/data/provider/api/vip/vip_rest_client.dart';

@lazySingleton
class AppRepository {
  final AppRestClient _appRestClient;

  AppRepository(this._appRestClient);

  Future<APPInfo> queryUpdateInfo(String version) {
    return _appRestClient
        .queryUpdateInfo(version)
        .then((value) => value.data);
  }
}
