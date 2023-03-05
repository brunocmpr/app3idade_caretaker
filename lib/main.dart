import 'package:flutter/material.dart';

void main() {
  runApp(const App3Idade());
}

class App3Idade extends StatelessWidget {
  const App3Idade({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3ª Idade Fácil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
