package app.net.sharemoe

import android.os.Bundle
//import com.baidu.mobstat.StatService
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 调试模式下，打开log开关，可以看到调试log
       // StatService.setDebugOn(true)
        // 设置app发布渠道
        //StatService.setAppChannel(this, "appChannel", true)
        // 设置app版本号
       // StatService.setAppVersionName(this, "1.0")
        // 设置Appkey
       // StatService.setAppKey("1c62ad79da")
        // 启动sdk
       // StatService.start(this)
    }
}