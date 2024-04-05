import 'package:flutter/material.dart';
import 'package:flutter_front_end/locator.dart';
import 'package:flutter_front_end/view/main_page.dart';
import 'package:provider/provider.dart';

import 'viewmodel/conversation_viewmodel.dart';
import 'viewmodel/setting_viewmodel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConversationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingViewModel(),
        ),
      ],
      child: const MainApp(),
    )
    
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}


