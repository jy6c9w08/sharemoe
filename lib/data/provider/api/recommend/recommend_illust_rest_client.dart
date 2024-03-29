// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/result.dart';

part 'recommend_illust_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: PicDomain.DOMAIN)
abstract class RecommendIllustRestClient {
  @factoryMethod
  factory RecommendIllustRestClient(@Named('main') Dio dio) = _RecommendIllustRestClient;

  @GET("/users/{userId}/recommendBookmarkIllusts")
  Future<Result<List<Illust>>> queryRecommendCollectIllustInfo(
      @Path("userId") int userId);
}
