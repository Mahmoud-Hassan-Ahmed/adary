import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SelectMutiple extends StatelessWidget {
  const SelectMutiple(
      {super.key,
      required this.selectedItems,
      required this.items,
      required this.onChange,
      required this.label});
  final List<SelectModel> selectedItems;
  final List<SelectModel> items;
  final ValueChanged<List<SelectModel>> onChange;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.APP_COLOR, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<SelectModel>(
          iconStyleData: const IconStyleData(
              iconEnabledColor: AppColors.APP_COLOR,
              iconDisabledColor: AppColors.APP_COLOR),
          isExpanded: true,
          hint: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: AppColors.APP_COLOR),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? selectedItems.remove(item)
                          : selectedItems.add(item);
                      onChange(selectedItems);
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          if (isSelected)
                            const Icon(
                              Icons.check_box_outlined,
                              color: AppColors.APP_COLOR,
                            )
                          else
                            const Icon(
                              Icons.check_box_outline_blank,
                              color: AppColors.APP_COLOR,
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(item.name,
                                style: Theme.of(context).textTheme.labelMedium),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          value: selectedItems.isEmpty ? null : selectedItems.last,
          onChanged: (value) {},
          selectedItemBuilder: (context) {
            return items.map(
              (item) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    selectedItems.map((item) => item.name).join(', '),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(left: 16, right: 8),
            height: 60,
            width: 140,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 60,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
