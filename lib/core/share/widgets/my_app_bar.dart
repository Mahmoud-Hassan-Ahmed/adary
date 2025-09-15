import 'package:adary/core/conts/style.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget MyAppBar({String? title}) => AppBar(
      title: Text(
        title ?? '',
        style: AbhayaLibre.copyWith(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
