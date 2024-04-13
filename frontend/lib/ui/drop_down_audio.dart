import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/ui/ui_helper.dart';
import 'package:flutter_front_end/viewmodel/setting_viewmodel.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

class MyDropDownAudio extends StatelessWidget {
  const MyDropDownAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select Audio Voice',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          children: [
            Consumer<SettingViewModel>(
              builder: (_, model, __) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    hint: Text(
                      'Select Item',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: model.audioLanguages
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: SizedBox(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                    value: model.curAudio,
                    onChanged: (String? value) {
                      model.curAudio = value!;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Play Audio'
                ),
                horizontalSpaceSmall,
                Consumer<SettingViewModel>(
                  builder: (_, model, __) {
                    return MSHCheckbox(
                      size: 24,
                      value: model.playAudio,
                      colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                        checkedColor: Colors.blue,
                      ),
                      style: MSHCheckboxStyle.stroke,
                      onChanged: (selected) {
                        model.playAudio = selected;
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}