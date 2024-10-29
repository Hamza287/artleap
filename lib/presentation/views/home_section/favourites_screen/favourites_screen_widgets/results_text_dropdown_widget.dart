import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_textstyle.dart';

class ResultsTextDropDownWidget extends ConsumerWidget {
  ResultsTextDropDownWidget({super.key});
  String? _selectedItem;
  List<String> _dropdownItems = [
    "Recently Added",
    "My Generations",
    "Community",
    "Advanced Filters"
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Results",
            style:
                AppTextstyle.interMedium(fontSize: 16, color: AppColors.white)),
        Container(
          height: 35,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: AppColors.indigo),
          child: Center(
            child: DropdownButton<String>(
              value: _selectedItem,
              hint: Text(
                'All',
                style: AppTextstyle.interRegular(
                    fontSize: 14, color: AppColors.white),
              ),
              icon: Icon(
                Icons.arrow_drop_down_sharp,
                color: AppColors.white,
              ),
              // elevation: 25,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                _selectedItem = newValue!;
              },
              items:
                  _dropdownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
