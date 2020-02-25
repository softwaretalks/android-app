import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

bool isReleased(){
  if (kReleaseMode) {
    return true;
  } else {
    return false;
    // Will be tree-shaked on release builds.
  }
}



bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}







//https://medium.com/flutter-community/flutter-ready-to-go-e59873f9d7de#9537

enum BuildMode {
  DEBUG,
  PROFILE,
  RELEASE
}

class DeviceUtils {

  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;
    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());


    return result;
  }




  static Future<AndroidDeviceInfo> androidDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.androidInfo;
  }

  static Future<IosDeviceInfo> iosDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.iosInfo;
  }



}