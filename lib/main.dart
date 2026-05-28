import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/auth_repository.dart';
import 'package:flutter_application_1/repository/datasource/AuthLocalDataSource.dart';
import 'package:flutter_application_1/repository/datasource/AuthRemoteDataSource.dart';
import 'package:flutter_application_1/screen/auth/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider<AuthRepository>(
      create: (_) => AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSourceImpl(),
        localDataSource: AuthLocalDataSourceImpl(),
      ),
      child: const MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.red),
      ),
      home: LoginPage(),
    );
  }
}