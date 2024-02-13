// // Package imports:
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'package:retrofit/http.dart';
//
// part 'ga_rest_client.g.dart';
//
// @Injectable()
// @RestApi(baseUrl: 'www.google-analytics.com')
// abstract class GARestClient {
//   @factoryMethod
//   factory GARestClient(Dio dio) = _GARestClient;
//
//   @POST("/mp/collect")
//   Future<String> postEvent(@Query("api_secret") String apiSecret,
//       @Query("measurement_id") String measurementId, Map<String, dynamic> body);
// }
