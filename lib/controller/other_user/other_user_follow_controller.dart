// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';

class OtherUserFollowController extends GetxController {
  final ScrollController scrollController = ScrollController();
final BookmarkedUser bookmarkedUser;

  OtherUserFollowController({required this.bookmarkedUser});
}
