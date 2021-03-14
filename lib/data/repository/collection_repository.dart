import 'package:injectable/injectable.dart';
import 'package:sharemoe/data/model/collection.dart';

import 'package:sharemoe/data/model/result.dart';
import 'package:sharemoe/data/provider/api/collection/collection_rest_client.dart';


@lazySingleton
class CollectionRepository {
  final CollectionRestClient _collectionRestClient;

  CollectionRepository(this._collectionRestClient);

  Future<Result<int>> queryCreateCollection(Map body, String authorization) {
    return _collectionRestClient
        .queryCreateCollectionInfo(body, authorization)
        .then((value) => value);
  }

  Future<bool> queryDeleteCollection(int collectionId) {
    return _collectionRestClient
        .queryDeleteCollectionInfo(collectionId)
        .then((value) => value.data);
  }

  Future<Result> queryUpdateCollection(int collectionId, Map body) {
    return _collectionRestClient
        .queryUpdateCollectionInfo(collectionId, body)
        .then((value) => value.data);
  }

  Future queryBulkDeleteCollection(int collectionId, List<int> illustIds) {
    return _collectionRestClient
        .queryBulkDeleteCollectionInfo(collectionId, illustIds)
        .then((value) => value);
  }

  Future<Result> queryAddIllustToCollection(
      int collectionId, List<int> illustIds) {
    return _collectionRestClient
        .queryAddIllustToCollectionInfo(collectionId, illustIds)
        .then((value) => value);
  }

  Future queryModifyCollectionCover(int collectionId, List<int> illustIds) {
    return _collectionRestClient
        .queryModifyCollectionCoverInfo(collectionId, illustIds)
        .then((value) => value);
  }

  Future<List<TagList>> queryTagComplement(String keyword) {
    return _collectionRestClient
        .queryTagComplementInfo(keyword)
        .then((value) => value.data);
  }
}
