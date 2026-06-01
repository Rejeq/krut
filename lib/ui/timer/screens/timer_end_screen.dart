import 'package:flutter/material.dart';

class TimerEndScreen extends StatelessWidget {
  const TimerEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Таймер завершен')),
      body: const Center(
        child: Text(
          'Поздравляем! Таймер завершен.',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
