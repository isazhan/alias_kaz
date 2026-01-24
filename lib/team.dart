import 'package:flutter/material.dart';
import 'level.dart';

class TeamSetupScreen extends StatefulWidget {
  const TeamSetupScreen({super.key});

  @override
  State<TeamSetupScreen> createState() => _TeamSetupScreenState();
}

class _TeamSetupScreenState extends State<TeamSetupScreen> {
  final TextEditingController _team1Controller = TextEditingController(text: 'Қырандар');
  final TextEditingController _team2Controller = TextEditingController(text: 'Тұлпарлар');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Командаларды баптау')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _team1Controller, decoration: const InputDecoration(labelText: '1-ші команда')),
            TextField(controller: _team2Controller, decoration: const InputDecoration(labelText: '2-ші команда')),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LevelScreen(teams: [_team1Controller.text, _team2Controller.text]))),
              child: const Text('Бастау'),
            ),
          ],
        ),
      ),
    );
  }
}