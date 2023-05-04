import 'dart:io';

import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/services/patient_service.dart';
import 'package:app3idade_caretaker/widgets/gallery_camera_picker.dart';
import 'package:app3idade_caretaker/widgets/selected_images_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PatientRegisterPage extends StatefulWidget {
  const PatientRegisterPage({Key? key}) : super(key: key);

  @override
  State<PatientRegisterPage> createState() => PatientRegisterPageState();
}

class PatientRegisterPageState extends State<PatientRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _firstName = 'Nome:';
  final _lastName = 'Sobrenome:';
  final _nickname = 'Apelido:';
  final double _labelWidth = 90;
  List<File> _images = [];
  final ImagePicker _imagePicker = ImagePicker();

  final PatientService patientService = PatientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar paciente'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _submit(context);
          }
        },
        child: const Icon(Icons.done),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildInputRow(_firstName, _firstNameController, TextInputType.name, validator: _mandatoryValidator),
              buildInputRow(_lastName, _lastNameController, TextInputType.name, validator: _mandatoryValidator),
              buildInputRow(_nickname, _nicknameController, TextInputType.name),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _selectImages,
                    child: const Text('Selecione fotos'),
                  ),
                  const SizedBox(width: 8.0),
                  Text(_images.isNotEmpty ? '${_images.length} imagem(ns) selecionadas' : 'Nenhuma imagem selecionada'),
                ],
              ),
              if (_images.isNotEmpty)
                SelectedImagesWidget(
                    images: _images,
                    onImageRemoved: (index) {
                      setState(() {
                        _images.removeAt(index);
                      });
                    }),
            ],
          ),
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

  void _submit(BuildContext context) async {
    String? nickname = _nicknameController.text.trim();
    nickname = nickname.isNotEmpty ? nickname : null;

    Patient patient = Patient.newPatient(_firstNameController.text.trim(), _lastNameController.text.trim(), nickname);
    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      await patientService.createPatient(patient, _images);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Paciente criado com sucesso")),
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

  Future<void> _selectImages() async {
    File? file = await showGalleryCameraPicker(context);
    if (file == null) return;
    if (_images.any((fileI) => fileI.path == file.path)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagem já adicionada')));
      return;
    }
    setState(() {
      _images.add(file);
    });
  }
}
