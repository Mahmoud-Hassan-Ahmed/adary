import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../model/body/language_model.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
