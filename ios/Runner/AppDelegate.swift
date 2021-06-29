import UIKit
import Flutter
//import BaiduMobStat

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
   //  BaiduMobStat.default().enableDebugOn = true
    // BaiduMobStat.default().startWithAppId("d7a60ad100")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
