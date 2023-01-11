import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/view/app_views.dart';
import '../../../categories/models/category_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';

class MultiSelectDropDown extends StatefulWidget {
  final List<CategoryModel> interests;
  final Function(List<CategoryModel>) onChanged;
  final String hintText;
  final List<CategoryModel>? userInterests;

  const MultiSelectDropDown({
    required this.interests,
    required this.onChanged,
    required this.hintText,
    this.userInterests,
    Key? key,
  }) : super(key: key);

  @override
  State<MultiSelectDropDown> createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {
  List<CategoryModel> selectedItems = [];
  String selectedText = "";

  @override
  void initState() {
    if (widget.userInterests != null) {
      selectedItems = widget.userInterests!.map((interest) => interest).toList();
      if (widget.userInterests!.isNotEmpty) {
        selectedText = widget.userInterests!
            .reduce((cat1, cat2) => CategoryModel(id: 0, name: "${cat1.name}, ${cat2.name}", image: ""))
            .name;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSize.s0,
      color: AppColors.white,
      shadowColor: AppColors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s32.r),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: AppColors.transparent,
          expansionTileTheme: const ExpansionTileThemeData(iconColor: AppColors.primaryRed),
        ),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.zero,
          title: CustomText(selectedItems.isNotEmpty ? selectedText : widget.hintText),
          children: List.generate(
            widget.interests.length,
            (index) => _ViewItem(
              item: widget.interests[index],
              isSelected: selectedItems.indexWhere((category) => category.id == widget.interests[index].id) != -1,
              onSelectItem: (value) {
                setState(() {
                  selectedItems.map((cat) => cat.id).toList().contains(value.id)
                      ? selectedItems.removeWhere((cat) => cat.id == value.id)
                      : selectedItems.add(value);
                  selectedText = selectedItems.isNotEmpty
                      ? selectedItems
                          .reduce((cat1, cat2) => CategoryModel(id: 0, name: "${cat1.name}, ${cat2.name}", image: ""))
                          .name
                      : "";
                  widget.onChanged(selectedItems);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  final CategoryModel item;
  final bool isSelected;
  final Function(CategoryModel) onSelectItem;

  const _ViewItem({required this.item, required this.isSelected, required this.onSelectItem, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isSelected,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.primaryRed,
      onChanged: (value) => onSelectItem(item),
      title: CustomText(item.name),
    );
  }
}
