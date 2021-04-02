import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';

class ArtistDetailController extends GetxController {
  final artist = Rx<Artist>();
  final int artistId;
  final ScrollController scrollController = ScrollController();

  ArtistDetailController({this.artistId});

  Future<Artist> getArtistData() async {
    return await getIt<ArtistRepository>().querySearchArtistById(artistId);
  }

  @override
  void onInit() {
    getArtistData().then((value) => artist.value = value);
    super.onInit();
  }
}
