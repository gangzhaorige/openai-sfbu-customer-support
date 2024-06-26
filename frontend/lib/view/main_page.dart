import 'package:flutter/material.dart';
import 'package:flutter_front_end/services/audio_services.dart';
import 'package:flutter_front_end/view/main_drawer.dart';

import '../locator.dart';
import 'main_page_bar.dart';
import 'main_page_chat.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const Scaffold(
        backgroundColor: Colors.black87,
        drawer: MyDrawer(),
        body: Column(
          children: [
            TopBar(),
            Expanded(child: Conversation()),
          ]
        ),
      ),
      
    );
  }
}

