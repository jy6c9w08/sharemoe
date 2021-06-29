import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/result.dart';

part 'rank_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: "https://pix.ipv4.host")
abstract class RankRestClient {
  @factoryMethod
  factory RankRestClient(Dio dio) =
      _RankRestClient;

  @GET("/ranks")
  Future<Result<List<Illust>>> queryIllustRankInfo(
      @Query("date") String date,
      @Query("mode") String mode,
      @Query("page") int page,
      @Query("pageSize") int pageSize);
}
