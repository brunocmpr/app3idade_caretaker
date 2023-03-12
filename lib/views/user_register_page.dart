import 'package:app3idade_caretaker/models/app_user.dart';
import 'package:app3idade_caretaker/services/customer_service.dart';
import 'package:flutter/material.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  State<UserRegisterPage> createState() => UserRegisterPageState();
}

class UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstName = 'Nome:';
  final _lastName = 'Sobrenome:';
  final _email = 'Email:';
  final _password = 'Senha:';
  final double _labelWidth = 90;

  final AppUserService appUserService = AppUserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar usuário'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildInputRow(_firstName, _firstNameController, TextInputType.name, _mandatoryValidator),
              buildInputRow(_lastName, _lastNameController, TextInputType.name, _mandatoryValidator),
              buildInputRow(_email, _emailController, TextInputType.emailAddress, _emailValidator),
              buildInputRow(_password, _passwordController, TextInputType.visiblePassword, _passwordValidator,
                  obscureText: true),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submit(context);
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputRow(
      String label, TextEditingController controller, TextInputType inputType, String? Function(String?) validator,
      {bool obscureText = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: _labelWidth, child: Text(label)),
        Expanded(
          child: TextFormField(
            keyboardType: inputType,
            controller: controller,
            validator: validator,
            obscureText: obscureText,
          ),
        )
      ],
    );
  }

  void _submit(BuildContext context) async {
    AppUser user = AppUser.newUser(_firstNameController.text.trim(), _lastNameController.text.trim(),
        _emailController.text.trim(), _passwordController.text);
    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      await appUserService.createAppUser(user);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Usuário criado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    }
  }

  String? _mandatoryValidator(value) {
    if (value!.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _passwordValidator(value) {
    if (value!.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    } else if (value!.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _emailValidator(value) {
    if (!_isEmail(value)) {
      return 'Insira um e-mail válido';
    }
    return null;
  }

  bool _isEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
