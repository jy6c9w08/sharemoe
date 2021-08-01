// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/data/model/search.dart';
import 'package:sharemoe/data/provider/api/search/search_rest_client.dart';

@lazySingleton
class SearchRepository {
  final SearchRestClient _searchRestClient;

  SearchRepository(this._searchRestClient);

//搜索建议
  Future<List<SearchKeywords>> querySearchSuggestions(
    String keyword,
  ) {
    return _searchRestClient
        .querySearchSuggestionsInfo(keyword)
        .then((value) => value.data);
  }

  Future<List<SearchKeywords>> queryPixivSearchSuggestions(
    String keyword,
  ) {
    return _searchRestClient
        .queryPixivSearchSuggestionsInfo(keyword)
        .then((value) => value.data);
  }

  Future<SearchKeywords> queryKeyWordsToTranslatedResult(
    String keyword,
  ) {
    return _searchRestClient
        .queryKeyWordsToTranslatedResultInfo(keyword)
        .then((value) => value.data);
  }

  Future<List<HotSearch>> queryHotSearchTags(
    String date,
  ) {
    return _searchRestClient
        .queryHotSearchTagsInfo(date)
        .then((value) => value.data);
  }
}
