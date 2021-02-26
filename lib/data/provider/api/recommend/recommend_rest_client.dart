import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/result.dart';

part 'recommend_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: "https://pix.ipv4.host")
abstract class RecommendRestClient {
  @factoryMethod
  factory RecommendRestClient(Dio dio, {@Named("baseUrl") String baseUrl}) =
      _RecommendRestClient;

  @GET("/users/{userId}/recommendBookmarkIllusts")
  Future<Result<List<Illust>>> queryRecommendCollectIllustInfo(
      @Path("userId") int userId);
}
