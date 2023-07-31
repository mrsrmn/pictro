import UIKit
import Firebase
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GeneratedPluginRegistrant.register(with: self)

      WorkmanagerPlugin.setPluginRegistrantCallback { registry in
          GeneratedPluginRegistrant.register(with: registry)
      }
      WorkmanagerPlugin.registerTask(withIdentifier: "emirs.scribble.bgtask")
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
