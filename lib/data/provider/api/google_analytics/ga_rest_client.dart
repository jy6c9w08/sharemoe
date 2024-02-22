// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'ga_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: 'https://www.google-analytics.com')
abstract class GARestClient {
  @factoryMethod
  factory GARestClient(@Named('GARest') Dio dio) = _GARestClient;

  @POST("/mp/collect")
  Future postEvent(@Query("api_secret") String apiSecret,
      @Query("measurement_id") String measurementId, Map<String, dynamic> body);
}
