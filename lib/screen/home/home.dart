import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/auth_token.dart';

class HomePage extends StatelessWidget {
  final AuthToken token;
  
  HomePage({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context)
   {
      return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                                  const Text(
                  'Авторизация',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  ],
                ),
              ),
        ),
        );
  }
}