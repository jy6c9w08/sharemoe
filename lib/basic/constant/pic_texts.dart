class TextZhForAboutPage {
  static String title = '关于我们';
  static String version = '0.1.4';
  static String description =
      'Just4Fun\nPixivc 出生于2018-10-01，是一位兴趣使然的工具酱。\n她精致（ui统一），敏捷（前后分离&纯js）。\n将提供以下有限的服务：pixiv日排行的浏览与免费高级会员热门排序搜索。她希望能在茫茫互联网留下一些存在的痕迹，翘首以盼大家能通过各大搜索引擎访问她（将有助于提升她的搜索排名），\n搜索关键词：Pixiv\n当前版本: 公测版 V0.1.1 201101 \n有任何使用上的疑问和建议，请反馈于官方群或论坛。\n\n更新内容：\n- 修复 评论加载的 bug\n- 修复 瀑布流流畅性问题\n- 功能 增加了个人画集\n- 功能 增加了猜你喜欢';
  static String versionInfo = 'Pixivic 官方客户端 $version beta';
  static String updateTitle = '$version 更新内容';
  static String updateInfo =
      'v0.1.4\n- 优化 表情包流畅度\n- 修复 登陆后画作加载逻辑\n- 修复 收藏的漫画加载错误\n- 功能 在设置中进行备用图源的临时切换\n   重新打开APP后会返回默认图源\n- 功能 图片加速下载通道\n  请暂时前往web端领取试用时长';
  static String savePicLabel = '图片的保存';
  static String savePic = '在图片详情页中，长按图片即可下载原图';
  static String forum = '访问论坛';
  static String rearEnd = '后端源码';
  static String frontEnd = '前端源码';
  static String donate = '捐赠我们';
  static String friend = '友链';
  static String webOfficial = '网页版';
  static String checkUpdate = '检查更新';
  static String noUpdate = '当前已是最新版本';
}

class TextCommon {
  static String logout = '登陆信息已过期，请重新登陆';
}

class TextZhLoginPage {
  static String head = 'Pixivic';
  static String welcomeLogin = '欢迎回来';
  static String welcomeRegister = '加入我们';
  static String tipLogin = '登录来进行收藏和关注';
  static String tipRegister = '注册来解锁更多姿势';
  static String userNameAndEmail = '用户名/邮箱';
  static String userName = '用户名';
  static String password = '密码';
  static String passwordRepeat = '重复密码';
  static String email = '邮箱';
  static String buttonLogin = '登录';
  static String buttonRegister = '注册';
  static String buttonLoginLoading = '登录中';
  static String buttonRegisterLoading = '注册中';
  static String verification = '验证码';
  static String loginSucceed = '登录成功';
  static String loginFailed = '登录失败，请检查输入信息和网络';
  static String loginMode = '已有账户？';
  static String registerMode = '没有账户？';
  static String registerFailed = '注册失败，请检查网络';
  static String registerSucceed = '注册成功，返回登录页面';
  static String forgetPassword = '忘记密码？';
  static String forgetPasswordTitle = '重置密码';
  static String mailForForget = '输入注册时的邮箱';
  static String mailForForgetSubmit = '提交';
  static String mailForForgetCancel = '取消';
  static String sure = '确定';
  static String errorPwdNotSame = '两次输入的密码不一致，请检查';
  static String errorNameUsed = '此用户名已有人使用，请进行更换';
  static String errorEmail = '邮箱格式输入错误，请检查';
  static String errorNameLength = '用户名长度需4-10位';
  static String errorPwdLength = '密码长度需8-20位';
  static String errorGetVerificationCode = '无法获取验证码';
  static String notLogin = '用户未登录，请登录后使用该功能';
  static String registerCode = '食用码';
  static String smsCode = '短验证码信';
  static String phoneNumber = '手机号';
}

class TextZhUserPage {
  static String info = '消息';
  static String fans = '粉丝';
  static String favorite = '我的收藏';
  static String follow = '我的关注';
  static String history = '历史记录';
  static String download = '下载列表';
  static String vipSpeed = '图片加速';
  static String logout = '退出登录';
  static String makerSureLogout = '确定要退出登录吗？';
}

class TextZhUserSetPage {
  static String mailboxVerification = '邮箱验证';
  static String notVerified = '未验证';
  static String verified = '已验证';
  static String changePassword = '修改密码';
  static String oldPassword = '旧密码';
  static String changeUsername = '修改用户名';
  static String changeEmailBinding = '邮箱换绑';
  static String confirmMailbox = '确认新邮箱';
  static String confirmUsername = '确认新用户名';
}

class TextZhPicDetailPage {
  static String follow = '关注画师';
  static String followed = '已关注';
  static String followError = '关注失败，请检查网络是否正常';
  static String downloadImage = '下载原图';
  static String requestDownloadAuthority = '请赋予程序下载权限';
  static String jumpToPixivDetail = '跳转pixiv详情';
  static String jumpToPixivArtist = '跳转pixiv画师';
  static String copyIllustId = '拷贝画作id';
  static String copyArtistId = '拷贝画师id';
  static String alreadyCopied = '已拷贝id至剪贴板';
  static String addToCollection = '添加至画集';
  static String addFirstCollection = '添加您的第一个画集';
  static String deleteCollectionTitle = '删除当前画集';
  static String deleteCollectionContent = '画集删除后将无法恢复，请谨慎操作!';
  static String deleteCollectionYes = '删除';
  static String deleteCollectionNo = '取消';
}

class TextZhArtistPage {
  static String follow = '关注画师';
  static String followed = '已关注';
  static String followError = '关注失败，请检查网络是否正常';
  static String alreadyCopied = '已拷贝id至剪贴板';
  static String needLogin = '请登录后再加载画师页面';
}

class TextZhFollowPage {
  static String title = '关注画师列表';
  static String httpLoadError = '加载错误，请检查网络';
  static String follow = '+关注';
  static String followed = '已关注';
  static String followError = '操作失败，请检查网络是否正常';
}

class TextZhCenterPage {
  static String spotlight = 'spotlight';
  static String community = '论坛';
  static String about = '关于我们';
  static String frontend = '前端';
  static String rearend = '后端';
  static String mobile = '移动端';
  static String friendUrl = '友链';
  static String collection = '画集';
  static String guessLike = '猜你喜欢';
  static String policy = '隐私政策';
  static String safety = '安全设定';
  static String setting = '设置';
  static String safetyTitle = '安全等级设定';
  static String safetyWarniOS =
      '注意！！\nPixivic 进行了严格的图片敏感信息过滤，默认安全等级为高等。\n您可以选择使用中高等的安全等级，但请知晓，此等级下展示的更多图片可能包含轻微暴露图片。\n这些图片可能会引起您的反感或不适。\n切换等级后请自行重启应用以更新相应内容';
  static String safetyWarnAndroid =
      '注意！！\nPixivic 进行了严格的图片敏感信息过滤，默认安全等级为高等。\n由于相关法规规定，应用将默认保持安全等级为高等';
  static String safetyLevelHigh = '高';
  static String safetyLevelLowHigh = '中高';
  static String pleaseLogin = '请登录后使用该功能';
}

class TextZhSpotlightPage {
  static String manga = '漫画';
  static String illust = '插画';
  static String httpLoadError = '加载错误，请检查网络';
  static String title = 'Spotlight';
}

class TextZhSearchPage {
  static String everybodyIsWatching = '大家都在搜';
  static String illustAndManga = '插画漫画';
  static String getCurrentError = '获取热门数据失败';
  static String connectError = '网络错误，请检查网络连接';
}

class TextZhPappBar {
  static String transAndSearch = '翻译然后搜索';
  static String idToArtist = 'ID搜画师';
  static String idToIllust = 'ID搜画作';
  static String networkError = '请求失败，请检查网络';
  static String translateError = '翻译失败，请检查网络';
  static String inputError = '请输入有效的字符';
  static String inputIsNotNum = '搜索ID时请仅输入数字';
  static String searchTimeout = '搜索超时，请重试';
  static String pleaseLogin = '请登录后再进行搜索';
  static String noImageSelected = '退出了以图搜图';
}

class TextZhUserListPage {
  static String theseUserBookmark = '这些用户也收藏了';
}

class TextZhCommentCell {
  static String comment = '评论';
  static String reply = '回复';
  static String addComment = '添加评论';
  static String addCommentHint = '添加公开评论';
  static String commentCannotBeBlank = '发表的评论不得为空';
  static String pleaseLogin = '请登录后再进行评论';
}

class TextZhUploadImage {
  static String unkownError = '遇到了未知的错误，请稍后重试';
  static String invalidKey = '无效的API';
  static String dailyLimit = '搜图次数已达24小时上限';
  static String shortLimit = '搜图过于频繁，请等待半分钟';
  static String fileTooLarge = '图片文件过大，请压缩后重试';
  static String similarityLow = '结果无匹配或匹配度过低';
  static String noImageButUrl = '无画作匹配，即将跳转相关网址';
}

class TextZhSettingPage {
  static String title = '设置';
  static String appData = '应用数据';
  static String deleteData = '清除图片缓存';
  static String deleteDataDetail = '清除设备上的预览图缓存';
  static String deleteDataDetailUnit = 'MB';
  static String dataRemainTime = '缓存保留时长';
  static String dataRemainTimeDetail = '预览图缓存经过设定的时间后将自动清理';
  static String dataRemainTimeDetailUnit = '天';
  static String imageLoad = '图片加载';
  static String reviewQuality = '预览图片质量';
  static String reviewQualityDetail = '图片质量越高，消耗流量越多';
  static String highQuality = '高';
  static String mediumQuality = '中';
  static String lowQuality = '低';
  static String changeImageUrl = '备用图源';
  static String changeImageUrlDetail = '当图片加载失败时可尝试临时切换至备用图源';
  static String appUpdate = '应用信息';
  static String checkUpdate = '关于我们';
  static String checkUpdateDetail = '查看版本信息以及应用更新';
}

class TextZhGuessLikePage {
  static String title = '猜你喜欢';
}

class TextZhCollection {
  static String newCollectionTitle = '添加新的画集';
  static String inputCollectionTitle = '输入画集名称';
  static String inputCollectionCaption = '输入画集介绍';
  static String isPulic = '公开画集';
  static String isSexy = 'R16内容';
  static String allowComment = '允许评论';
  static String addTag = '添加标签';
  static String removeCollection = '移除画集';
  static String createCollection = '创建画集';
  static String editCollection = '提交修改';
  static String needForTag = '请添加至少一个标签';
  static String needForTitle = '请输入标题';
  static String needForCaption = '请输入介绍';
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
  static const String RECOMMEND = "recommend";
}

class PicDomain {
  static const String DOMAIN = 'https://pix.ipv4.host';
}

class PicExternalLinkLink {
  static const String ZCWD = 'https://url.ipv4.host/zcwd';
  static const String ZCTB = 'https://url.ipv4.host/zctb';
  static const String JSTB = 'https://url.ipv4.host/jstb';
  static const String RZTB = 'https://url.ipv4.host/zctb';
  static const String RZWD = 'https://url.ipv4.host/zcwd';
  static const String WD = 'https://url.ipv4.host/wd';
  static const String DISCUSS = 'https://url.ipv4.host/discuss';
  static const String APP_ANDROID_32 = 'https://url.ipv4.host/app_android_32';
  static const String APP_ANDROID_64 = 'https://url.ipv4.host/app_android_64';
}
