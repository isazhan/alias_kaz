import 'package:flutter/material.dart';

class LevelScreen extends StatefulWidget {
  final List<String> teams;
  const LevelScreen({super.key, required this.teams});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  double _targetScore = 30; // Әдепкі бойынша 30 ұпай

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ойын баптаулары')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Жеңіс үшін қажетті ұпай:', style: TextStyle(fontSize: 18)),
            Text('${_targetScore.toInt()}', 
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
            
            Slider(
              value: _targetScore,
              min: 10,
              max: 30,
              divisions: 2,
              label: _targetScore.round().toString(),
              onChanged: (value) => setState(() => _targetScore = value),
            ),
            
            const SizedBox(height: 40),
            const Text('Қиындық деңгейі:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            _levelButton(context, 'Оңай', Colors.green),
            _levelButton(context, 'Орташа', Colors.orange),
            _levelButton(context, 'Қиын', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _levelButton(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, minimumSize: const Size(200, 50)),
        onPressed: () {
          Navigator.pushNamed(context, '/game', arguments: {
            'teams': widget.teams,
            'difficulty': title,
            'targetScore': _targetScore.toInt(), // Осы жерде ұпайды жібереміз
          });
        },
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}