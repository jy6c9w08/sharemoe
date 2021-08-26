// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

// Project imports:
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/result.dart';

part 'artist_rest_client.g.dart';

@lazySingleton
@RestApi(baseUrl: PicDomain.DOMAIN)
abstract class ArtistRestClient {
  @factoryMethod
  factory ArtistRestClient(Dio dio) =
      _ArtistRestClient;

  @GET("/artists/{artistId}/illusts/{type}")
  Future<Result<List<Illust>>> queryArtistIllustListInfo(
      @Path("artistId") int artistId,
      @Path("type") String type,
      @Query("page") int page,
      @Query("pageSize") int pageSize,
      @Query("maxSanityLevel") int maxSanityLevel);

  @GET("/artists/{artistId}")
  Future<Result<Artist>> querySearchArtistByIdInfo(@Path() int artistId,);

  @GET("/artists/{artistId}/summary")
  Future<Result<ArtistSummary>> queryArtistIllustSummaryInfo(
      @Path("artistId") int artistId);

  // @GET("/artists/{artistId}/followedUsers")

  @GET("/artists")
  Future<Result<List<Artist>>> querySearchArtistInfo(
      @Query("artistName") String artistName,
      @Query("page") int page,
      @Query("pageSize") int pageSize);
}
