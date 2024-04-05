import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/ui/drop_down_audio.dart';
import 'package:flutter_front_end/ui/drop_down_translate.dart';
import 'package:flutter_front_end/ui/ui_helper.dart';
import 'package:flutter_front_end/viewmodel/setting_viewmodel.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = const [
      SizedBox(
        height: 100,
        width: 100,
        child: Image(
          image: AssetImage('assets/SFBU-logo.png')
        ),
      ),
      MyDropDownTranslate(),
      MyDropDownAudio(),
      horizontalSpaceSmall,
    ];

    return Drawer(
      child: ListView.separated(
        itemCount: widgets.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        padding: EdgeInsets.zero,
        itemBuilder:(context, index) {
          return widgets[index];
        },
      ),
    );
  }
}