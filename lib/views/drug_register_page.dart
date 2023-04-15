import 'dart:io';

import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/repository/drug_repository.dart';
import 'package:app3idade_caretaker/services/drug_service.dart';
// import 'package:app3idade_caretaker/services/drug_service.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class DrugRegisterPage extends StatefulWidget {
  const DrugRegisterPage({Key? key}) : super(key: key);
  @override
  State<DrugRegisterPage> createState() => _DrugRegisterPageState();
}

class _DrugRegisterPageState extends State<DrugRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<File> _images = [];
  final _name = 'Nome:';
  final _strength = 'Strength:';
  final double _labelWidth = 90;

  final DrugService drugService = DrugService();

  void _submit(BuildContext context) async {
    Drug drug = Drug.newDrug(_nameController.text.trim(), _strengthController.text.trim());
    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      await drugService.createDrug(drug, _images);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Medicamento criado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    }
  }

  Future<void> _selectImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();
    setState(() {
      _images = images.map((xfile) => File(xfile.path)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar medicamento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            buildInputRow(_name, _nameController, TextInputType.name, validator: _mandatoryValidator),
            buildInputRow(_strength, _strengthController, TextInputType.name, validator: _mandatoryValidator),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _selectImages,
                  child: const Text('Selecione fotos'),
                ),
                const SizedBox(width: 8.0),
                Text(_images.isEmpty ? '${_images.length} imagem(ns) selecionadas' : 'Nenhuma imagem selecionada'),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submit(context);
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputRow(String label, TextEditingController controller, TextInputType inputType,
      {String? Function(String?)? validator, bool obscureText = false}) {
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

  String? _mandatoryValidator(value) {
    if (value!.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
