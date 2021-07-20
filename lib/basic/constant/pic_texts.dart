class TextZhForAboutPage {
  String title = '关于我们';
  static String version = '0.1.4';
  String description =
      'Just4Fun\nPixivc 出生于2018-10-01，是一位兴趣使然的工具酱。\n她精致（ui统一），敏捷（前后分离&纯js）。\n将提供以下有限的服务：pixiv日排行的浏览与免费高级会员热门排序搜索。她希望能在茫茫互联网留下一些存在的痕迹，翘首以盼大家能通过各大搜索引擎访问她（将有助于提升她的搜索排名），\n搜索关键词：Pixiv\n当前版本: 公测版 V0.1.1 201101 \n有任何使用上的疑问和建议，请反馈于官方群或论坛。\n\n更新内容：\n- 修复 评论加载的 bug\n- 修复 瀑布流流畅性问题\n- 功能 增加了个人画集\n- 功能 增加了猜你喜欢';
  String versionInfo = 'Pixivic 官方客户端 $version beta';
  String updateTitle = '$version 更新内容';
  String updateInfo =
      'v0.1.4\n- 优化 表情包流畅度\n- 修复 登陆后画作加载逻辑\n- 修复 收藏的漫画加载错误\n- 功能 在设置中进行备用图源的临时切换\n   重新打开APP后会返回默认图源\n- 功能 图片加速下载通道\n  请暂时前往web端领取试用时长';
  String savePicLabel = '图片的保存';
  String savePic = '在图片详情页中，长按图片即可下载原图';
  String forum = '访问论坛';
  String rearEnd = '后端源码';
  String frontEnd = '前端源码';
  String donate = '捐赠我们';
  String friend = '友链';
  String webOfficial = '网页版';
  String checkUpdate = '检查更新';
  String noUpdate = '当前已是最新版本';
}

class TextCommon {
  static String logout = '登陆信息已过期，请重新登陆';
}

class TextZhLoginPage {
  String head = 'Pixivic';
  String welcomeLogin = '欢迎回来';
  String welcomeRegister = '加入我们';
  String tipLogin = '登录来进行收藏和关注';
  String tipRegister = '注册来解锁更多姿势';
  String userNameAndEmail = '用户名/邮箱';
  String userName = '用户名';
  String password = '密码';
  String passwordRepeat = '重复密码';
  String email = '邮箱';
  String buttonLogin = '登录';
  String buttonRegister = '注册';
  String buttonLoginLoading = '登录中';
  String buttonRegisterLoading = '注册中';
  String verification = '验证码';
  String loginSucceed = '登录成功';
  String loginFailed = '登录失败，请检查输入信息和网络';
  String loginMode = '已有账户？';
  String registerMode = '没有账户？';
  String registerFailed = '注册失败，请检查网络';
  String registerSucceed = '注册成功，返回登录页面';
  String forgetPassword = '忘记密码？';
  String forgetPasswordTitle = '重置密码';
  String mailForForget = '输入注册时的邮箱';
  String mailForForgetSubmit = '提交';
  String mailForForgetCancel = '取消';
  String sure = '确定';
  String errorPwdNotSame = '两次输入的密码不一致，请检查';
  String errorNameUsed = '此用户名已有人使用，请进行更换';
  String errorEmail = '邮箱格式输入错误，请检查';
  String errorNameLength = '用户名长度需4-10位';
  String errorPwdLength = '密码长度需8-20位';
  String errorGetVerificationCode = '无法获取验证码';
  String notLogin = '用户未登录，请登录后使用该功能';
  String registerCode='食用码';
  String smsCode='短验证码信';
  String phoneNumber='手机号';
}

class TextZhUserPage {
  String info = '消息';
  String fans = '粉丝';
  String favorite = '我的收藏';
  String follow = '我的关注';
  String history = '历史记录';
  String download = '下载列表';
  String vipSpeed = '图片加速';
  String logout = '退出登录';
  String makerSureLogout = '确定要退出登录吗？';
}

class TextZhPicDetailPage {
  String follow = '关注画师';
  String followed = '已关注';
  String followError = '关注失败，请检查网络是否正常';
  String downloadImage = '下载原图';
  String requestDownloadAuthority = '请赋予程序下载权限';
  String jumpToPixivDetail = '跳转pixiv详情';
  String jumpToPixivArtist = '跳转pixiv画师';
  String copyIllustId = '拷贝画作id';
  String copyArtistId = '拷贝画师id';
  String alreadyCopied = '已拷贝id至剪贴板';
  String addToCollection = '添加至画集';
  String addFirstCollection = '添加您的第一个画集';
  String deleteCollectionTitle = '删除当前画集';
  String deleteCollectionContent = '画集删除后将无法恢复，请谨慎操作!';
  String deleteCollectionYes = '删除';
  String deleteCollectionNo = '取消';
}

class TextZhArtistPage {
  String follow = '关注画师';
  String followed = '已关注';
  String followError = '关注失败，请检查网络是否正常';
  String alreadyCopied = '已拷贝id至剪贴板';
  String needLogin = '请登录后再加载画师页面';
}

class TextZhFollowPage {
  String title = '关注画师列表';
  String httpLoadError = '加载错误，请检查网络';
  String follow = '+关注';
  String followed = '已关注';
  String followError = '操作失败，请检查网络是否正常';
}

class TextZhCenterPage {
  String spotlight = 'spotlight';
  String community = '论坛';
  String about = '关于我们';
  String frontend = '前端';
  String rearend = '后端';
  String mobile = '移动端';
  String friendUrl = '友链';
  String collection = '画集';
  String guessLike = '猜你喜欢';
  String policy = '隐私政策';
  String safety = '安全设定';
  String setting = '设置';
  String safetyTitle = '安全等级设定';
  String safetyWarniOS =
      '注意！！\nPixivic 进行了严格的图片敏感信息过滤，默认安全等级为高等。\n您可以选择使用中高等的安全等级，但请知晓，此等级下展示的更多图片可能包含轻微暴露图片。\n这些图片可能会引起您的反感或不适。\n切换等级后请自行重启应用以更新相应内容';
  String safetyWarnAndroid =
      '注意！！\nPixivic 进行了严格的图片敏感信息过滤，默认安全等级为高等。\n由于相关法规规定，应用将默认保持安全等级为高等';
  String safetyLevelHigh = '高';
  String safetyLevelLowHigh = '中高';
  String pleaseLogin = '请登录后使用该功能';
}

class TextZhSpotlightPage {
  String manga = '漫画';
  String illust = '插画';
  String httpLoadError = '加载错误，请检查网络';
  String title = 'Spotlight';
}

class TextZhSearchPage {
  String everybodyIsWatching = '大家都在搜';
  String illustAndManga = '插画漫画';
  String getCurrentError = '获取热门数据失败';
  String connectError = '网络错误，请检查网络连接';
}

class TextZhPappBar {
  String transAndSearch = '翻译然后搜索';
  String idToArtist = 'ID搜画师';
  String idToIllust = 'ID搜画作';
  String networkError = '请求失败，请检查网络';
  String translateError = '翻译失败，请检查网络';
  String inputError = '请输入有效的字符';
  String inputIsNotNum = '搜索ID时请仅输入数字';
  String searchTimeout = '搜索超时，请重试';
  String pleaseLogin = '请登录后再进行搜索';
  String noImageSelected = '退出了以图搜图';
}

class TextZhUserListPage {
  String theseUserBookmark = '这些用户也收藏了';
}

class TextZhCommentCell {
  String comment = '评论';
  String reply = '回复';
  String addComment = '添加评论';
  String addCommentHint = '添加公开评论';
  String commentCannotBeBlank = '发表的评论不得为空';
  String pleaseLogin = '请登录后再进行评论';
}

class TextZhUploadImage {
  String unkownError = '遇到了未知的错误，请稍后重试';
  String invalidKey = '无效的API';
  String dailyLimit = '搜图次数已达24小时上限';
  String shortLimit = '搜图过于频繁，请等待半分钟';
  String fileTooLarge = '图片文件过大，请压缩后重试';
  String similarityLow = '结果无匹配或匹配度过低';
  String noImageButUrl = '无画作匹配，即将跳转相关网址';
}

class TextZhSettingPage {
  String title = '设置';
  String appData = '应用数据';
  String deleteData = '清除图片缓存';
  String deleteDataDetail = '清除设备上的预览图缓存';
  String deleteDataDetailUnit = 'MB';
  String dataRemainTime = '缓存保留时长';
  String dataRemainTimeDetail = '预览图缓存经过设定的时间后将自动清理';
  String dataRemainTimeDetailUnit = '天';
  String imageLoad = '图片加载';
  String reviewQuality = '预览图片质量';
  String reviewQualityDetail = '图片质量越高，消耗流量越多';
  String highQuality = '高';
  String mediumQuality = '中';
  String lowQuality = '低';
  String changeImageUrl = '备用图源';
  String changeImageUrlDetail = '当图片加载失败时可尝试临时切换至备用图源';
  String appUpdate = '应用信息';
  String checkUpdate = '关于我们';
  String checkUpdateDetail = '查看版本信息以及应用更新';
}

class TextZhGuessLikePage {
  String title = '猜你喜欢';
}

class TextZhCollection {
  String newCollectionTitle = '添加新的画集';
  String inputCollectionTitle = '输入画集名称';
  String inputCollectionCaption = '输入画集介绍';
  String isPulic = '公开画集';
  String isSexy = 'R16内容';
  String allowComment = '允许评论';
  String addTag = '添加标签';
  String removeCollection = '移除画集';
  String createCollection = '创建画集';
  String editCollection = '提交修改';
  String needForTag = '请添加至少一个标签';
  String needForTitle = '请输入标题';
  String needForCaption = '请输入介绍';
}

class TextZhVIP {
  static String notVip = '您还不是会员';
  static String endTime = '会员有效期至:';
  static String code = '兑换码';
  static String convert = '立即兑换';
  static String learnMore = '了解如何使用兑换码';
}

class PicType {
  static String comments = "comments";
  static String illusts = "illusts";
  static String illust = "illust";
  static String manga = "manga";
  static String artists = "artists";
  static String collections = "collections";
  static String discussion = "discussions";
  static String users = "users";
  static String attendances = "attendances";
}

class PicModel {
  static const String HOME = "home";
  static const String SEARCH = "search";
  static const String RELATED = "related";
  static const String ARTIST = "artist";
  static const String HISTORY = "history";
  static const String OLDHISTORY = "oldHistory";
  static const String UPDATE = "update";
  static const String COLLECTION = "collection";
}
