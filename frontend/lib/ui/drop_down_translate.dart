import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/ui/ui_helper.dart';
import 'package:flutter_front_end/viewmodel/setting_viewmodel.dart';
import 'package:provider/provider.dart';

class MyDropDownTranslate extends StatelessWidget {
  const MyDropDownTranslate({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Select Response Language',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpaceSmall,
        Consumer<SettingViewModel>(
          builder: (_, model, __) {
            return DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: model.translateLanguages
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ))
                  .toList(),
                value: model.curTranslateLanguage,
                onChanged: (String? value) {
                  model.curTranslateLanguage = value!;
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  // height: 40,
                  // width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}