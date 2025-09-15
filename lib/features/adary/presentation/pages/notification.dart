import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/navBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  double hight = 165;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              AppNavBar(
                  imagePath: Images.APP_ICON, headerTxt: "التنبيهات".tr()),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("مسح الكل",
                        style: AbhayaLibreBold.copyWith(
                            fontSize: 18, decoration: TextDecoration.underline))
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ExpansionTile(
                iconColor: Color(0xff1A6A7D),
                collapsedIconColor: Color(0xffD9D9D9),
                title: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Color(0xffFFFFFF),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(-1, 8), // Shadow position
                              ),
                            ]),
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Image.asset(
                                  Images.APP_ICON,
                                  width: 30,
                                  height: 30,
                                )))),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'SchoolTable'.tr(),
                          style: AbhayaLibreBold.copyWith(fontSize: 19),
                        ),
                      ],
                    )
                  ],
                ),
                subtitle: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 65),
                    child: Text(
                      " 16/5/1445 هـ يوم 2 قبل ",
                      style: AbhayaLibre.copyWith(color: Color(0xff5C5C5C)),
                    )),
                trailing: SvgPicture.asset(
                  Images.MoreDown,
                ),
                children: <Widget>[
                  ListTile(
                      title: Text(
                          'الاشعار الاشعار الاشعار الاشعار الاشعار الاشعار الاشعار الاشعار الاشعار الاشعار الاشعار الاشعار...  ')),
                  GestureDetector(
                      onTap: () {
                        _showMyDialog();
                      },
                      child: ListTile(title: SvgPicture.asset(Images.TRASH))),
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'هل انت متأكد من حذف الشعار؟',
                  style: AbhayaLibre.copyWith(
                      color: Color(0xff060606), fontSize: 20),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff060606),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextButton(
                    child: Text(
                      'نعم',
                      style: AbhayaLibre.copyWith(
                          color: Colors.white, fontSize: 19),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xff95989A))),
                  child: TextButton(
                    child: Text(
                      'لا',
                      style: AbhayaLibre.copyWith(
                          color: Color(0xff060606), fontSize: 19),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
