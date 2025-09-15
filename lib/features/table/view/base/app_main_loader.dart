import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppLoader extends StatelessWidget {
  Widget loaderView;

  AppLoader({super.key, required this.loaderView});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.grey.withOpacity(0.8),
        enabled: true,
        child: loaderView);
  }
}
