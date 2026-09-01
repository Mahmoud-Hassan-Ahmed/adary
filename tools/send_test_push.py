"""يرسل إشعارًا تجريبيًا إلى جهاز واحد عبر FCM HTTP v1.

يفصل هذا جانبَ الجهاز عن جانب الخادم فصلًا قاطعًا: إن وصل الإشعار من هنا
فالتطبيق و APNs و Firebase سليمة جميعًا، ويكون الخلل فيما يرسله خادمكم.

يلزمه مفتاح حساب خدمة — لا `google-services.json`، فذاك إعداد عميل لا يخوّل
الإرسال. ومفتاح الخادم القديم (Authorization: key=…) أوقفته جوجل في يونيو ٢٠٢٤.

  التحميل: Firebase Console ← ⚙ Project settings ← Service accounts
           ← Generate new private key

  الاستعمال:
    python tools/send_test_push.py <مسار-المفتاح.json> <رمز-الجهاز> [--data-only]
"""

import json
import sys

import google.auth.transport.requests
import requests
from google.oauth2 import service_account

SCOPE = "https://www.googleapis.com/auth/firebase.messaging"


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if len(args) != 2:
        print(__doc__)
        return 2

    key_path, token = args
    data_only = "--data-only" in sys.argv

    with open(key_path, encoding="utf-8") as handle:
        project_id = json.load(handle)["project_id"]

    credentials = service_account.Credentials.from_service_account_file(
        key_path, scopes=[SCOPE]
    )
    credentials.refresh(google.auth.transport.requests.Request())

    message = {"token": token}

    if "--server-shape" in sys.argv:
        # نسخة طبق الأصل مما يبنيه الخادم في
        # api/utilities.py::send_fcm_bulk_notif — ليُختبر مسارُه هو لا رسالةٌ
        # عامة قد تنجح حيث يفشل.
        message["notification"] = {
            "title": "تأمين حصة",
            "body": "طلب تأمين حصة جديد بانتظار موافقتك.",
        }
        message["data"] = {"action_id": "secure_class_0"}
        message["android"] = {"priority": "high"}
        message["apns"] = {
            "payload": {"aps": {"sound": "default", "mutable-content": 1}}
        }
    elif data_only:
        # بلا كتلة notification: يفيد في اختبار ما إذا كان الخادم يرسل رسائل
        # بيانات فقط — وتلك لا يعرضها iOS من تلقائه أصلًا.
        message["data"] = {"action_id": "secure_class_0"}
        message["apns"] = {"headers": {"apns-priority": "5"},
                           "payload": {"aps": {"content-available": 1}}}
    else:
        message["notification"] = {
            "title": "اختبار الإشعارات",
            "body": "إن ظهر هذا الإشعار فالمسار سليم من Firebase إلى جهازك.",
        }
        # `action_id` بالصيغة التي يرسلها الخادم، ليُختبر فتح الشاشة أيضًا.
        message["data"] = {"action_id": "secure_class_0"}
        message["apns"] = {
            "headers": {"apns-priority": "10"},
            "payload": {"aps": {"sound": "default", "badge": 1}},
        }
        message["android"] = {"priority": "high"}

    response = requests.post(
        f"https://fcm.googleapis.com/v1/projects/{project_id}/messages:send",
        headers={"Authorization": f"Bearer {credentials.token}"},
        json={"message": message},
        timeout=30,
    )

    print(f"المشروع: {project_id}")
    print(f"الحالة : {response.status_code}")
    print(response.text)

    if response.status_code == 200:
        print("\n✓ قبلت Firebase الرسالة وسلّمتها إلى أبل/جوجل.")
        print("  لم تصل الجهاز؟ إذن الخلل بين المزوّد والجهاز لا في خادمكم.")
    elif response.status_code == 404:
        print("\n!! UNREGISTERED — الرمز لم يعد صالحًا: حُذف التطبيق أو أُعيد")
        print("   تثبيته أو أُعيد توقيعه. خذ رمزًا جديدًا من شاشة التشخيص.")
    elif response.status_code == 403:
        print("\n!! مفتاح الخدمة لا يخصّ المشروع نفسه، أو ينقصه تفعيل FCM API.")
    return 0 if response.status_code == 200 else 1


if __name__ == "__main__":
    raise SystemExit(main())
