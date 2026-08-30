import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  /// سبب رفض أبل تسجيلَ الجهاز في APNs، إن رفضت.
  ///
  /// من جهة دارت يعود `getAPNSToken()` بـ nil بلا بيان سبب، وهذا الموضع هو
  /// الوحيد الذي يصل إليه السبب. وأشهره أن التطبيق وُقّع بلا حق
  /// `aps-environment` لأن الـ provisioning profile لا يحمل خاصية Push:
  /// "no valid 'aps-environment' entitlement string found for application".
  ///
  /// وبقاؤه فارغًا مع تعذّر الرمز دلالةٌ أخرى: التسجيل لم يُطلب أصلًا.
  private var apnsFailure: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      FlutterMethodChannel(
        name: "adary/apns",
        binaryMessenger: controller.binaryMessenger
      ).setMethodCallHandler { [weak self] call, result in
        if call.method == "lastFailure" {
          result(self?.apnsFailure)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    apnsFailure = error.localizedDescription
    NSLog("[إشعارات] رفضت أبل تسجيل الجهاز: %@", error.localizedDescription)
    super.application(
      application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
}
