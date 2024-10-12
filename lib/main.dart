import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_sensor/di.dart';
import 'package:todo_sensor/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupRepositories();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ToDo - Sensor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xffFCFCFE)),
      routerConfig: router,
    );
  }
}
