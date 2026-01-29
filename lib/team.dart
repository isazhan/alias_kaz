import 'package:flutter/material.dart';
import 'level.dart';
import 'globals.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [myColor4, myColor1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Командаларды баптау')
          ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _team1Controller,
                decoration: InputDecoration(
                  labelText: '1-ші команда',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all( Radius.circular(20)),
                  ),
                  fillColor: myColor1,
                  filled: true
                )
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _team2Controller,
                decoration: InputDecoration(
                  labelText: '2-ші команда',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all( Radius.circular(20)),
                  ),
                  fillColor: myColor1,
                  filled: true
                )
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: myColor3, minimumSize: const Size(200, 50)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LevelScreen(teams: [_team1Controller.text, _team2Controller.text]))),
                child: const Text('Жалғастыру', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      )
    );
  }
}