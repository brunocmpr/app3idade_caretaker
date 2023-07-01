import 'dart:io';

import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/services/network_image_service.dart';
import 'package:app3idade_caretaker/services/patient_service.dart';
import 'package:app3idade_caretaker/widgets/gallery_camera_picker.dart';
import 'package:app3idade_caretaker/widgets/selected_images_widget.dart';
import 'package:flutter/material.dart';

class PatientUpdatePage extends StatefulWidget {
  final int patientId;

  const PatientUpdatePage({Key? key, required this.patientId}) : super(key: key);

  @override
  State<PatientUpdatePage> createState() => PatientUpdatePageState();
}

class PatientUpdatePageState extends State<PatientUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late Patient _patient;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _networkImageService = NetworkImageService();
  static const _firstName = 'Nome:';
  static const _lastName = 'Sobrenome:';
  static const _nickname = 'Apelido:';
  static const double _labelWidth = 90;
  static const int maxImages = 1;
  List<File> _images = [];
  bool _isLoading = true;

  final patientService = PatientService();

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    try {
      _patient = await patientService.findById(widget.patientId);
      _populateFormFields();
      await _populateImages();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateFormFields() {
    _firstNameController.text = _patient.firstName;
    _lastNameController.text = _patient.lastName;
    _nicknameController.text = _patient.nickname ?? '';
  }

  Future<void> _populateImages() async {
    if (_patient.imageIds == null) return;
    var images = await _networkImageService.fetchImages(_patient.imageIds!);
    setState(() {
      _images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar paciente'),
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
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _isLoading,
            child: Opacity(
              opacity: _isLoading ? 0.5 : 1.0,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildInputRow(_firstName, _firstNameController, TextInputType.name,
                          validator: _mandatoryValidator),
                      buildInputRow(_lastName, _lastNameController, TextInputType.name, validator: _mandatoryValidator),
                      buildInputRow(_nickname, _nicknameController, TextInputType.name),
                      const SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _images.length < maxImages ? _selectImages : null,
                            child: const Text('Selecione foto'),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            _images.isNotEmpty
                                ? '${_images.length} image${_images.length == 1 ? 'm' : 'ns'}'
                                    ' selecionada${_images.length == 1 ? '' : 's'}'
                                : 'Nenhuma imagem selecionada',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_images.isNotEmpty)
                        SelectedImagesWidget(
                          images: _images,
                          displayImageCount: false,
                          onImageRemoved: (index) {
                            setState(() {
                              _images.removeAt(index);
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
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
        ),
      ],
    );
  }

  void _submit(BuildContext context) async {
    String? nickname = _nicknameController.text.trim();
    nickname = nickname.isNotEmpty ? nickname : null;

    _patient.firstName = _firstNameController.text.trim();
    _patient.lastName = _lastNameController.text.trim();
    _patient.nickname = nickname;
    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      setState(() {
        _isLoading = true;
      });
      await patientService.update(_patient, _images);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Paciente atualizado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _mandatoryValidator(value) {
    if (value!.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Future<void> _selectImages() async {
    if (_images.length >= maxImages) {
      const msg = '${maxImages > 1 ? 'São' : 'É'} permitida ${maxImages > 1 ? 's' : ''} até '
          '$maxImages foto ${maxImages > 1 ? 's' : ''}';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(msg)));
      return;
    }
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
