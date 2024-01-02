// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/result.dart';

part 'search_for_picture_client.g.dart';

@Injectable()
@RestApi(baseUrl: PicDomain.DOMAIN)
abstract class SearchForPictureClient {
  @factoryMethod
  factory SearchForPictureClient(Dio dio) =
      _SearchForPictureClient;

  //上传图片
  @POST("/images")
  Future<Result<String>> queryPostImageInfo(@Part() File image,
      @ReceiveProgress() ProgressCallback onReceiveProgress);

  //搜索图片
  @GET("/similarImages")
  Future<Result<List<Illust>>> querySearchIllustInfo(
    @Query("imageUrl") String imageUrl,
  );
}
