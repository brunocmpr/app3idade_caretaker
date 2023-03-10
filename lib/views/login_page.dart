import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Preencha o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Preencha a senha';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _submit(context),
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final email = _emailController.text;
      final password = _passwordController.text;

      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      final token = await _authService.login(email, password);
      setState(() {
        _isLoading = false;
      });
      if (token != null) {
        navigator.pushNamed(Routes.homePage, arguments: token);
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Credenciais inválidas"),
          ),
        );
      }
    }
  }
}
