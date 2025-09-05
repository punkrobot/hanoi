import 'package:app/config/dependency_injection.dart';
import 'package:app/data/services/device/log.dart';
import 'package:app/ui/main/view/main_view.dart';
import 'package:app/ui/shared/theme.dart';
import 'package:flutter/material.dart';

void main() {
  Log.init();
  DI.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Towers of Hanoi',
      theme: appTheme,
      home: const SafeArea(child: MainView()),
    );
  }
}
