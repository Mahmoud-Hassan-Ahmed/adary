import 'package:adary/features/table/data/repository/calender_repository.dart';
import 'package:get/get.dart';

class DropDownController extends GetxController {
  late CalenderRepository _calenderRepository;
  DropDownController({required CalenderRepository calenderRepository}) {
    _calenderRepository = calenderRepository;
  }
}
