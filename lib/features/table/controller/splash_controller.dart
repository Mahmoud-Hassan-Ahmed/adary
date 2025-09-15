// import 'dart:async';

// import 'package:adary/features/table/controller/authintication_controller.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http_parser/http_parser.dart';

// import '../data/repository/splash_repo.dart';
// import '../helper/route_helper.dart';
// import 'package:easy_localization/easy_localization.dart' as easy;

// class splashController extends GetxController implements GetxService {
//   // depencency injection
//   late SplashRepo _splashRepo;
//   splashController({required SplashRepo splashRepo}) {
//     _splashRepo = splashRepo;
//   }

//   final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

//   final DateTime _currentTime = DateTime.now();
//   bool _firstTimeConnectionCheck = true;

//   DateTime get currentTime => _currentTime;
//   bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

//   @override
//   onInit() {
//     super.onInit();
//     checkFirstTimeState();
//   }

//   late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

//   void checkFirstTimeState() {
//     bool _firstTime = true;
//     _onConnectivityChanged = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       if (!_firstTime) {
//         bool isNotConnected = result != ConnectivityResult.wifi &&
//             result != ConnectivityResult.mobile;
//         isNotConnected
//             ? SizedBox()
//             : ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
//         ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
//           backgroundColor: isNotConnected ? Colors.red : Colors.green,
//           duration: Duration(seconds: isNotConnected ? 6000 : 3),
//           content: Text(
//             isNotConnected ? easy.tr('no_connection') : easy.tr('connected'),
//             textAlign: TextAlign.center,
//           ),
//         ));
//         if (!isNotConnected) {
//           _route();
//         }
//       }
//       _firstTime = false;
//     });

//     initSharedData();
//     _route();
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _onConnectivityChanged.cancel();
//   }

//   void _route() {
//     Timer(const Duration(seconds: 3), () async {
//       if (Get.find<AuthenticationController>().isLoggedIn()) {
//         Get.offNamed(RouteHelper.geDashBoardRoute());
//       } else {
//         Get.offAllNamed(RouteHelper.geLoginRoute());
//       }
//     });
//   }

//   Future<bool> initSharedData() {
//     return _splashRepo.initSharedData();
//   }

//   Future<bool> removeSharedData() {
//     return _splashRepo.removeSharedData();
//   }

//   bool showIntro() {
//     return _splashRepo.showIntro();
//   }

//   void setIntro(bool intro) {
//     _splashRepo.setIntro(intro);
//   }

//   void setFirstTimeConnectionCheck(bool isChecked) {
//     _firstTimeConnectionCheck = isChecked;
//   }
// }
