# تفعيل إشعارات تطبيق المدير (Smartble M)

كود التطبيق جاهز، والخادم يرسل الإشعار فعلًا عند إرسال المعلم طلب تأمين حصة
(`teacher_mobile/v2/apis/secure_class_notify.py`). الباقي خطوات في لوحة Firebase
ولوحة Apple لأنها تُصدر مفاتيح لا يمكن توليدها من الكود.

البناء يجري على **Codemagic**، فخطوات Xcode اليدوية مؤتمتة في `codemagic.yaml`.

---

## ١. أضف التطبيقين إلى مشروع Firebase نفسه

يجب أن يكون **`smarttable-44f51`** — وهو المشروع الذي يستعمله الخادم
(`smarttable/firebase_pk.json`) وتطبيق المعلم. تطبيق في مشروع آخر يعطي رموزًا
لا يستطيع الخادم مخاطبتها.

| المنصة  | المعرّف                | الملف                                  |
| ------- | ---------------------- | -------------------------------------- |
| Android | `com.smartable.tables` | `android/app/google-services.json`     |
| iOS     | `com.smartapleP.in`    | `ios/Runner/GoogleService-Info.plist`  |

نزّلهما من [console.firebase.google.com](https://console.firebase.google.com)
← Project settings ← Your apps.

### أين تضعهما؟

المستودع **عام**، وملفات إعدادات Firebase ليست أسرارًا بمعناها الدقيق (تُشحن
داخل التطبيق نفسه على كل جهاز)، لكن الأنظف حقنها من Codemagic:

**أ. حقنًا من Codemagic (مُستحسن)** — في Environment variables ضمن المجموعة
`teacher_credentials`، أضف متغيّرين **Secure**:

| المتغيّر                     | القيمة                                  |
| ---------------------------- | --------------------------------------- |
| `GOOGLE_SERVICES_INFO_PLIST` | `base64 -i GoogleService-Info.plist`     |
| `GOOGLE_SERVICES_JSON`       | `base64 -i google-services.json`         |

على ويندوز:
`certutil -encode GoogleService-Info.plist tmp.txt` ثم انسخ ما بين السطرين.

**ب. أو ارفعهما إلى المستودع** — خطوة `Restore Firebase config files` في
`codemagic.yaml` تستعمل الملف المرفوع تلقائيًا حين لا يكون المتغيّر مضبوطًا،
فالمسارَان يعملان.

> ⚠️ **بناء أندرويد يفشل قبل وضع `google-services.json`** برسالة
> `File google-services.json is missing`. وأندرويد يُبنى محليًا عندك — لا يوجد
> `android-workflow` في `codemagic.yaml` — فضع الملف في `android/app/` على جهازك.

---

## ٢. خطوة واحدة في لوحة Apple (لا غنى عنها)

من [developer.apple.com](https://developer.apple.com/account/resources/identifiers):
افتح الـ App ID الخاص بـ **`com.smartapleP.in`** ← فعّل **Push Notifications** ← Save.

بلا هذا يفشل بناء Codemagic عند التوقيع برسالة:
`Provisioning profile ... doesn't include the aps-environment entitlement`.

ثم ارفع مفتاح APNs (`.p8`) إلى Firebase:
Project settings ← Cloud Messaging ← Apple app configuration ← APNs Authentication Key.
بلا المفتاح لا يستطيع Firebase تسليم الإشعار إلى أجهزة iOS إطلاقًا.

---

## ٣. ما الذي تكفّل به `codemagic.yaml` بدلًا عن Xcode

أُضيفت خطوتان قبل `pod install`:

- **Restore Firebase config files** — يكتب الملفين من المتغيّرات السرّية إن وُجدت.
- **Wire Firebase files into Xcode project** — يشغّل
  [`ios/scripts/configure_firebase.rb`](ios/scripts/configure_firebase.rb) الذي:
  1. يُدرج `GoogleService-Info.plist` عضوًا في هدف Runner — بلا ذلك لا يُنسخ
     داخل حزمة التطبيق ويفشل `Firebase.initializeApp` وقت التشغيل، ونسخ الملف
     في المجلد وحده لا يكفي.
  2. يربط `ios/Runner/Runner.entitlements` بـ `CODE_SIGN_ENTITLEMENTS` ليحمل
     التطبيق حق `aps-environment`.

  السكربت لا يكرّر ما فعله، وإعادة تشغيله على مشروع مُعدّ لا تغيّر شيئًا.

---

## ٤. تحقّق

1. سجّل الدخول في تطبيق المدير، وابحث في الـ log عن `FCM token: ...`
2. تأكد أن الخادم حفظه:
   ```python
   DashboardMobile.objects.get(school_id=<id>).fcm_token
   ```
3. أرسل طلب تأمين حصة من تطبيق المعلم لنفس المدرسة — يصل الإشعار،
   والضغط عليه يفتح شاشة «طلبات تأمين الحصة».

---

## ما الذي أُضيف في الكود

- `lib/core/services/push_notifications_service.dart` — تهيئة Firebase، طلب الإذن،
  جلب الرمز وإرساله، عرض إشعار المقدمة، وفتح الشاشة عند الضغط
- `Api.fcmTokenUpdate` ← `dashboard-mobile/fcm-token-update/`
- استدعاء `syncToken()` بعد تسجيل الدخول (`AppUtilsImp.login`) وعند كل إقلاع
- إذن `POST_NOTIFICATIONS` وقناة `high_importance_channel` في `AndroidManifest.xml`
- `UIBackgroundModes` في `ios/Runner/Info.plist`
  (و`aps-environment` نُقل منه إلى `Runner.entitlements` — النظام لا يقرؤه من
  `Info.plist` فكان بلا أثر)
- `ios/Runner/Runner.entitlements` و`ios/scripts/configure_firebase.rb`
- خطوتان في `codemagic.yaml`
