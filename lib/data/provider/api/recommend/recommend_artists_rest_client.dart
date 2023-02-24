// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/result.dart';

part 'recommend_artists_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl:PicDomain.DOMAIN)
abstract class RecommendArtistsRestClient {
  @factoryMethod
  factory RecommendArtistsRestClient(Dio dio,{String baseUrl}) =
  _RecommendArtistsRestClient;

  @GET("/users/{userId}/recommendArtists")
  Future<Result<List<Artist>>> queryRecommendArtistsInfo(
      @Path("userId") int userId);
}