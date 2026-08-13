import 'package:flutter/material.dart';

import 'screens/gameplay_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Root Application shell widget.
class BlockChangeApp extends StatelessWidget {
  const BlockChangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block Change',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/gameplay': (context) => const GameplayScreen(),
      },
    );
  }
}
