import UIKit
import Firebase
import Flutter
import WidgetKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let widgetChannel = FlutterMethodChannel(
        name: "widgets.emirs.pictro",
        binaryMessenger: controller.binaryMessenger
      )
      widgetChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "getWidgetStatus" else {
              result(FlutterMethodNotImplemented)
              return
          }
          WidgetCenter.shared.getCurrentConfigurations { [result] widgetResult in
              if case let .success(configurations) = widgetResult {
                  if configurations.contains(where: { $0.kind == "Pictro" }) {
                      result(Bool(true))
                  } else {
                      result(Bool(false))
                  }
              }
          }
      })
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
