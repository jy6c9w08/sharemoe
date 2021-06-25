import 'package:sharemoe/basic/config/hive_config.dart';

late String vipUrl;

class PicUrl {
  final String url;
  final String mode;
  late String imageUrl;

  PicUrl({required this.url, this.mode = 'normal'}) {
    if (AuthBox().auth == '') {
      normal();
    } else if (AuthBox().permissionLevel > 2) {
      vip();
    } else {
      normal();
    }
  }

  normal() {
    if (mode == 'original')
      imageUrl = url.replaceAll('https://i.pximg.net', 'https://o.acgpic.net');
    else
      imageUrl = url.replaceAll('https://i.pximg.net', 'https://acgpic.net');
  }

  vip() {
    if (mode == 'original')
      imageUrl = url.replaceAll('https://i.pximg.net', vipUrl) +
          '?Authorization=${AuthBox().auth}';
    else
      imageUrl = url.replaceAll('https://i.pximg.net', 'https://acgpic.net');
  }

  spare() {}
}
