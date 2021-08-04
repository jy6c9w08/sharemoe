// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';

class ArtistDetailController extends GetxController {
  final Artist artist;
  // final int artistId;
  final ScrollController scrollController = ScrollController();
  static final ArtistRepository artistRepository = getIt<ArtistRepository>();

  ArtistDetailController({required this.artist});

  Future<Artist> getArtistData() async {
    return await artistRepository.querySearchArtistById(artist.id!);
  }

  @override
  onInit(){
    // getArtistData().then((value) {
    //    artist = value;
    // });
    super.onInit();
  }
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
