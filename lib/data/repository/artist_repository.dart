import 'package:injectable/injectable.dart';

import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/provider/api/artist/artist_rest_client.dart';

@lazySingleton
class ArtistRepository {
  final ArtistRestClient _artistRestClient;

  ArtistRepository(this._artistRestClient);

  Future<List<Illust>> queryArtistIllustList(
      int artistId, String type, int page, int pageSize, int maxSanityLevel) {
    return _artistRestClient
        .queryArtistIllustListInfo(
        artistId, type, page, pageSize, maxSanityLevel)
        .then((value) => value.data);
  }

  Future<Artist> querySearchArtistById(int artistId,
      {Function onReceiveProgress}) {
    return _artistRestClient
        .querySearchArtistByIdInfo(artistId, onReceiveProgress)
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
}
