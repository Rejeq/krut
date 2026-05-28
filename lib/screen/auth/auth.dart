import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/auth_token.dart';
import 'package:flutter_application_1/repository/auth_repository.dart';
import 'package:flutter_application_1/screen/home/home.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}


class _LoginState extends State<LoginPage> {

  final TextEditingController loginController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

   bool is_error = false;
   Color get authColor =>
      is_error ? Colors.red : Colors.black;

late final AuthRepository repository;

@override
void initState() {
  super.initState();
  repository = context.read<AuthRepository>();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                'Авторизация',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: authColor,
                ),
              ),

              const SizedBox(height: 30),

              // Поле логина
              TextField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              // Поле пароля
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 30),

              // Кнопка входа
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {

                    String login = loginController.text;
                    String password =
                        passwordController.text;

                    print('Логин: $login');
                    print('Пароль: $password');
                    
                    try {
                    final token = await repository.getToken(login: login, password: password);
                    setState(() {
                          is_error = false;
                      });
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(token: token)),
                      );
                    } catch (e) {
                      setState(() {
                          is_error = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    'Войти',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}