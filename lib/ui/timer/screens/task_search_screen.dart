import 'package:flutter/material.dart';

class TaskSearchScreen extends StatelessWidget {
  const TaskSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поиск задач')),
      body: const Center(
        child: Text('Здесь будет поиск задач'),
      ),
    );
  }
}
