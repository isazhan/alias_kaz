import 'package:flutter/material.dart';
import 'menu.dart';
import 'team.dart';
import 'game.dart';

void main() => runApp(const AliasApp());

class AliasApp extends StatelessWidget {
  const AliasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alias Қазақша',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/team': (context) => const TeamSetupScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}