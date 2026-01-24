import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Alias Қазақша', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/team'),
              child: const Text('Жаңа ойын'),
            ),
            const SizedBox(height: 10),
            const ElevatedButton(
              onPressed: null, // Кнопка пока неактивна
              child: Text('Жалғастыру'),
            ),
          ],
        ),
      ),
    );
  }
}