import 'package:injectable/injectable.dart';

import 'package:sharemoe/data/provider/api/rank/rank_rest_client.dart';
import 'package:sharemoe/data/model/illust.dart';



@lazySingleton
class IllustRepository {
  final RankRestClient _rankRestClient;

  IllustRepository(this._rankRestClient);


  Future<List<Illust>> queryIllustRank(
      String date, String mode, int page, int pageSize) {
    return _rankRestClient
        .queryIllustRankInfo(date, mode, page, pageSize)
        .then((value) => value.data);
  }

}
