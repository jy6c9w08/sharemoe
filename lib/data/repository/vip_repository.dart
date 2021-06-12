import 'package:injectable/injectable.dart';
import 'package:sharemoe/data/model/server_address.dart';
import 'package:sharemoe/data/provider/api/vip/vip_rest_client.dart';

@lazySingleton
class VIPRepository {
  final VipRestClient _vipRestClient;

  VIPRepository(this._vipRestClient);

  Future<bool> queryGetVIPCode(int illustId, Map<String, dynamic> body) {
    return _vipRestClient
        .queryGetVIPCodeInfo(illustId, body)
        .then((value) => value.data);
  }

  Future<List<ServerAddress>> queryGetHighSpeedServer() {
    return _vipRestClient
        .queryGetHighSpeedServerInfo()
        .then((value) => value.data);
  }
}
