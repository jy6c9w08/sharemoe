// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/provider/api/artist/artist_rest_client.dart';
import 'package:sharemoe/data/provider/api/recommend/recommend_artists_rest_client.dart';

@lazySingleton
class ArtistRepository {
  final ArtistRestClient _artistRestClient;
  final RecommendArtistsRestClient _recommendArtistsRestClient;

  ArtistRepository(this._artistRestClient, this._recommendArtistsRestClient);

  Future<List<Illust>> queryArtistIllustList(
      int artistId, String type, int page, int pageSize, int maxSanityLevel) {
    return _artistRestClient
        .queryArtistIllustListInfo(
            artistId, type, page, pageSize, maxSanityLevel)
        .then((value) => value.data);
  }

  Future<Artist> querySearchArtistById(
    int artistId,
  ) {
    return _artistRestClient
        .querySearchArtistByIdInfo(artistId)
        .then((value) => value.data);
  }

  Future<ArtistSummary> queryArtistIllustSummary(int artistId) {
    return _artistRestClient
        .queryArtistIllustSummaryInfo(artistId)
        .then((value) => value.data);
  }

  Future<List<Artist>> querySearchArtist(
      String artistName, int page, int pageSize) {
    return _artistRestClient
        .querySearchArtistInfo(artistName, page, pageSize)
        .then((value) => value.data);
  }

  Future<List<Artist>> queryGuessLikeArtist(int userId) {
    return _recommendArtistsRestClient
        .queryRecommendArtistsInfo(userId)
        .then((value) => value.data);
  }
}
