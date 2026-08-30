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
        switch call.method {
        case "lastFailure":
          result(self?.apnsFailure)
        case "apsFromProfile":
          // الحقيقة من الحزمة المثبَّتة نفسها، لا من مخرجات البناء: يُقرأ
          // embedded.mobileprovision الملتصق بالتطبيق الجاري. تعارضُه مع ما
          // تحقّق منه Codemagic يعني أن المثبَّت ليس ما بُني.
          result(Self.apsEnvironmentFromEmbeddedProfile())
        case "isRegistered":
          result(UIApplication.shared.isRegisteredForRemoteNotifications)
        case "retryRegistration":
          // تسجيلٌ جديد الآن، ليكون سبب الرفض طازجًا لا محفوظًا من إقلاعٍ سابق.
          self?.apnsFailure = nil
          UIApplication.shared.registerForRemoteNotifications()
          result(nil)
        case "buildInfo":
          // نسخة الحزمة الجارية فعلًا على الجهاز. تُقارن بما بناه Codemagic:
          // اختلافهما يعني أن التصليح لم يصل الجهاز، وهو أشيع من أن يُهمل.
          let info = Bundle.main.infoDictionary
          let name = info?["CFBundleShortVersionString"] as? String ?? "?"
          let build = info?["CFBundleVersion"] as? String ?? "?"
          result("\(name) (\(build))")
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// قيمة `aps-environment` في الـ provisioning profile المرفق بالحزمة.
  ///
  /// الملف موقَّع بصيغة CMS، والجزء المقروء منه نصُّ plist في وسطه — فيُقتطع
  /// بين وسمَي البداية والنهاية بدل فكّ التوقيع، إذ لا يعني هنا إلا محتواه.
  private static func apsEnvironmentFromEmbeddedProfile() -> String? {
    guard let path = Bundle.main.path(
            forResource: "embedded", ofType: "mobileprovision"),
          let raw = try? Data(contentsOf: URL(fileURLWithPath: path)),
          let text = String(data: raw, encoding: .isoLatin1),
          let start = text.range(of: "<?xml"),
          let end = text.range(of: "</plist>")
    else { return nil }

    let xml = String(text[start.lowerBound..<end.upperBound])
    guard let data = xml.data(using: .isoLatin1),
          let plist = try? PropertyListSerialization.propertyList(
            from: data, options: [], format: nil) as? [String: Any],
          let entitlements = plist["Entitlements"] as? [String: Any]
    else { return nil }

    return entitlements["aps-environment"] as? String
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
