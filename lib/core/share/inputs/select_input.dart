import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectInput extends StatelessWidget {
  const SelectInput(
      {super.key,
      required this.items,
      this.selectedValue,
      required this.onChanged,
      this.fontSize = 14,
      this.icon,
      required this.label});

  final List<SelectModel> items;
  final SelectModel? selectedValue;
  final ValueChanged<SelectModel?> onChanged;
  final String label;
  final Widget? icon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    final TextEditingController validatorController =
        TextEditingController(text: selectedValue?.name);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.APP_COLOR, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          TextFormField(
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            controller: validatorController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'اختر العنصر';
              }
              return null;
            },
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: icon ?? Container(),
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<SelectModel>(
                    iconStyleData: IconStyleData(
                        icon: SvgPicture.asset(
                      AppIcon.dropDown,
                      color: AppColors.APP_COLOR,
                    )),
                    // selectedItemBuilder: (context) => [const Text('')],
                    hint: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<SelectModel>(
                              value: item,
                              child: Text(
                                item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontSize: fontSize),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: onChanged,
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 55,
                      width: 200,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 65,
                    ),

                    // dropdownSearchData: DropdownSearchData(
                    //   searchController: textEditingController,
                    //   searchInnerWidgetHeight: 50,
                    //   searchInnerWidget: Container(
                    //     height: 60,
                    //     padding: const EdgeInsets.only(
                    //       top: 8,
                    //       bottom: 4,
                    //       right: 8,
                    //       left: 8,
                    //     ),
                    //     child: TextFormField(
                    //       expands: true,
                    //       maxLines: null,
                    //       controller: textEditingController,
                    //       decoration: InputDecoration(
                    //         isDense: true,
                    //         contentPadding: const EdgeInsets.symmetric(
                    //           horizontal: 10,
                    //           vertical: 8,
                    //         ),
                    //         hintText: 'Search for an item...'.tr(),
                    //         hintStyle: const TextStyle(fontSize: 12),
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   searchMatchFn: (item, searchValue) {
                    //     return item.value.toString().contains(searchValue);
                    //   },
                    // ),
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingController.clear();
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
