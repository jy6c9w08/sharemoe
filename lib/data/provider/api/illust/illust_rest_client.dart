// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/result.dart';

part 'illust_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: "https://pix.ipv4.host")
abstract class IllustRestClient {
  @factoryMethod
  factory IllustRestClient(Dio dio) =
      _IllustRestClient;

  @GET("/illusts/{illustId}")
  Future<Result<Illust>> querySearchIllustByIdInfo(
    @Path("illustId") int illustId,
  );

  @GET("/illusts/{illustId}/related")
  Future<Result<List<Illust>>> queryRelatedIllustListInfo(
      @Path("illustId") num illustId,
      @Query("page") int page,
      @Query("pageSize") int pageSize);

  @GET("/illusts/{illustId}/bookmarkedUsers")
  Future<Result<List<BookmarkedUser>>> queryUserOfCollectionIllustListInfo(
      @Path("illustId") num illustId,
      @Query("page") int page,
      @Query("pageSize") int pageSize);
}
