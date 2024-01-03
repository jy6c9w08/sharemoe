// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/app_info.dart';
import 'package:sharemoe/data/model/image_url_pre.dart';
import 'package:sharemoe/data/model/result.dart';

part 'app_rest_client.g.dart';

@lazySingleton
@RestApi(baseUrl: PicDomain.DOMAIN)
abstract class AppRestClient {
  @factoryMethod
  factory AppRestClient(Dio dio) = _AppRestClient;

  @GET("/app/latest")
  Future<Result<APPInfo>> queryUpdateInfo(
      @Query("version") String version, @Query("platform") String platform);

  @GET("/app/imageUrlPre")
  Future<Result<ImageUrlPre>> queryImageUrlPreInfo();
}
