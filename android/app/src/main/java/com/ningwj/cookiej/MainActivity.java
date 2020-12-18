package com.ningwj.cookiej;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  //通讯名称,回到手机桌面
  private  final String CHANNEL = "android/back/desktop";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                    (methodCall, result) -> {
                      if (methodCall.method.equals("backDesktop")) {
                          result.success(true);
                          moveTaskToBack(false);
                      } 
               }
        );
    }
}
