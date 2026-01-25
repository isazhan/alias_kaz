import 'package:flutter/material.dart';
import 'background.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /////////////// Фон ///////////////
          CustomPaint(
            size: Size.infinite,
            painter: BackgroundPainter(),
          ),
          /////////////// Меню ///////////////
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 200, height: 200),
                const SizedBox(height: 200),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, minimumSize: const Size(200, 50)),
                  onPressed: () => Navigator.pushNamed(context, '/team'),
                  child: const Text('Жаңа ойын', style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
          /////////////// Меню ///////////////
        ],
      ),
    );
  }
}