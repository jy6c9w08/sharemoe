import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:retrofit/retrofit.dart';

import 'package:sharemoe/data/model/result.dart';

part 'search_for_picture_client.g.dart';

@Injectable()
@RestApi(baseUrl: "https://pix.ipv4.host")
abstract class SearchForPictureClient {
  @factoryMethod
  factory SearchForPictureClient(Dio dio, {@Named("baseUrl") String baseUrl}) =
      _SearchForPictureClient;

  //上传图片
  @POST("https://cbir.pixivic.com/images")
  Future<Result<String>> queryPostImageInfo(@Part(value: 'image') File body,
      @SendProgress() ProgressCallback onReceiveProgress);

  //搜索图片
  @GET("/similarImages")
  Future<Result<List<Illust>>> querySearchIllustInfo(
    @Query("imageUrl") String imageUrl,
  );
}
