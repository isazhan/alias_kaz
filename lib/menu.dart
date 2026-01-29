import 'package:flutter/material.dart';
import 'globals.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo //
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset('assets/logo.png', width: 200, height: 200),
              ),
              // Placehold //
              const SizedBox(height: 100),
              // Button //
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: myColor3, minimumSize: const Size(200, 50)),
                onPressed: () => Navigator.pushNamed(context, '/team'),
                child: const Text('Жаңа ойын', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}