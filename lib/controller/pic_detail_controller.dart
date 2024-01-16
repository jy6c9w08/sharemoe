// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/artist/artist_detail_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PicDetailController extends GetxController {
  final int illustId;
  late bool isReady = false;
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();

  PicDetailController({required this.illustId});

  uploadHistory() async {
    Map<String, String> body = {
      'userId': userService.userInfo()!.id.toString(),
      'illustId': illustId.toString()
    };
    await userRepository.postNewUserViewIllustHistory(
        userService.userInfo()!.id, body);
  }

  Future getArtistData() async {
    getIt<ArtistRepository>()
        .querySearchArtistById(
            Get.find<ImageController>(tag: illustId.toString())
                .illust
                .artistId!)
        .then((value) {
      Get.lazyPut(() => ArtistDetailController(artist: value),
          tag: value.id.toString());
      isReady = true;
      update(['updateArtist']);
    });
  }

  jumpHtml(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void onInit() {
    if (userService.isLogin()) {
      uploadHistory();
    }
    ;
    getArtistData();
    super.onInit();
  }
}
