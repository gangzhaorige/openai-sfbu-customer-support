import 'package:flutter/material.dart';
import 'package:flutter_front_end/ui/drop_down_audio.dart';
import 'package:flutter_front_end/ui/drop_down_translate.dart';
import 'package:flutter_front_end/ui/ui_helper.dart';

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
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: widgets[index],
          );
        },
      ),
    );
  }
}