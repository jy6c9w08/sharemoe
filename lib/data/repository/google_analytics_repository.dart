//Package imports:

import 'package:injectable/injectable.dart';
import 'package:sharemoe/data/provider/api/google_analytics/ga_rest_client.dart';

@lazySingleton
class GARepository {
  final GARestClient _gaRestClient;

  GARepository(this._gaRestClient);

  Future postEvent(
      String apiSecret, String measurementId, Map<String, dynamic> body) {
    return _gaRestClient.postEvent(apiSecret, measurementId, body);
  }
}
