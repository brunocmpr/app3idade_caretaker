import 'package:flutter/material.dart';
import 'package:app3idade_caretaker/services/auth_service.dart';

class HomePage extends StatelessWidget {
  final String token;
  final AuthService _authService = AuthService();

  HomePage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You are logged in! Token: $token',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _authService.logoutAndGoToLogin(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
