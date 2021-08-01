// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/data/model/server_address.dart';
import 'package:sharemoe/data/provider/api/vip/vip_rest_client.dart';

@lazySingleton
class VIPRepository {
  final VipRestClient _vipRestClient;

  VIPRepository(this._vipRestClient);

  Future queryGetVIP(int userId, String exchangeCode) {
    return _vipRestClient
        .queryGetVIPInfo(userId, exchangeCode)
        .then((value) => value);
  }

  Future<List<ServerAddress>> queryGetHighSpeedServer() {
    return _vipRestClient
        .queryGetHighSpeedServerInfo()
        .then((value) => value.data);
  }
}
