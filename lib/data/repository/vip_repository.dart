import 'package:injectable/injectable.dart';
import 'package:sharemoe/data/provider/api/vip/vip_rest_client.dart';

@lazySingleton
class VIPRepository {
  final VipRestClient _vipRestClient;

  VIPRepository(this._vipRestClient);

  Future<bool> queryFollowedWithRecentlyIllusts(
      int illustId, Map<String, dynamic> body) {
    return _vipRestClient
        .queryGetVIPCodeInfo(illustId, body)
        .then((value) => value.data);
  }
}
