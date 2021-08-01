// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/result.dart';
import 'package:sharemoe/data/model/search.dart';

part 'search_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: "https://pix.ipv4.host")
abstract class SearchRestClient {
  @factoryMethod
  factory SearchRestClient(Dio dio) =
  _SearchRestClient;

  @GET("/keywords/{keyword}/suggestions")
  Future<Result<List<SearchKeywords>>> querySearchSuggestionsInfo(
      @Path("keyword") String keyword);

  @GET("/keywords/{keyword}/pixivSuggestions")
  Future<Result<List<SearchKeywords>>> queryPixivSearchSuggestionsInfo(
      @Path("keyword") String keyword);

  @GET("/keywords/{keyword}/translations")
  Future<Result<SearchKeywords>> queryKeyWordsToTranslatedResultInfo(
      @Path("keyword") String keyword);

  @GET("/illustrations")
  Future<Result<List<Illust>>> querySearchListInfo(
      // @Queries() Map<String, dynamic> queries
      @Query("keyword") String keyword,
      @Query("pageSize") int pageSize,
      @Query("page") int page,
      // @Query("searchType") String searchType,
      // @Query("illustType") String illustType,
      // @Query("minWidth") double minWidth,
      // @Query("minHeight") double minHeight,
      // @Query("endDate") String endDate,
      // @Query("xRestrict") String xRestrict,
      // @Query("maxSanityLevel") String maxSanityLevel,
      );

  @GET("/similarityImages")
  Future<Result<List<Illust>>> querySearchForPicturesInfo(
      @Query("imageUrl") String imageUrl);

  //类型不定
  @GET("/trendingTags")
  Future<Result<List<HotSearch>>> queryHotSearchTagsInfo(
      @Query("date") String date);
}
