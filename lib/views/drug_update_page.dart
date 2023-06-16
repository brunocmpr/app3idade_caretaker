import 'dart:io';

import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/drug_service.dart';
import 'package:app3idade_caretaker/services/network_image_service.dart';
import 'package:app3idade_caretaker/widgets/gallery_camera_picker.dart';
import 'package:app3idade_caretaker/widgets/selected_images_widget.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class DrugUpdatePage extends StatefulWidget {
  final int drugId;

  const DrugUpdatePage({Key? key, required this.drugId}) : super(key: key);
  @override
  State<DrugUpdatePage> createState() => _DrugUpdatePageState();
}

class _DrugUpdatePageState extends State<DrugUpdatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Drug _drug;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  List<File> _images = [];
  String? _instructions;
  static const _name = 'Nome:';
  static const _strength = 'Dose (ex: 50 mg):';
  static const int maxImages = 5;
  static const double _labelWidth = 150;
  bool _isLoading = true;

  final DrugService drugService = DrugService();
  final _networkImageService = NetworkImageService();

  @override
  void initState() {
    super.initState();
    _fetchDrugData();
  }

  Future<void> _fetchDrugData() async {
    try {
      _drug = await drugService.findById(widget.drugId);
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
    _nameController.text = _drug.name;
    _strengthController.text = _drug.strength;
    _instructions = _drug.instructions;
  }

  Future<void> _populateImages() async {
    if (_drug.imageIds == null) return;
    var images = await _networkImageService.fetchImages(_drug.imageIds!);
    setState(() {
      _images = images;
    });
  }

  void _submit(BuildContext context) async {
    _drug.name = _nameController.text;
    _drug.strength = _strengthController.text;
    _drug.instructions = _instructions;
    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      await drugService.update(_drug, _images);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Medicamento atualizado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar medicamento'),
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
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    buildInputRow(_name, _nameController, TextInputType.name, validator: _mandatoryValidator),
                    buildInputRow(_strength, _strengthController, TextInputType.name),
                    const SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _images.length < maxImages ? _selectImages : null,
                          child: const Text('Selecione fotos'),
                        ),
                        const SizedBox(width: 8.0),
                        Text(_images.isNotEmpty
                            ? '${_images.length} imagem(ns) selecionadas'
                            : 'Nenhuma imagem selecionada'),
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
                    const SizedBox(height: 16.0),
                    const Text('Instruções:'),
                    ElevatedButton(
                      onPressed: () async {
                        String? richText =
                            await Navigator.pushNamed(context, Routes.richTextEditor, arguments: _instructions)
                                as String?;
                        if (richText != null) {
                          setState(() => _instructions = richText);
                        }
                      },
                      child: const Text('Adicionar texto de instruções'),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        String? richText =
                            await Navigator.pushNamed(context, Routes.richTextEditor, arguments: _instructions)
                                as String?;
                        if (richText != null) {
                          setState(() => _instructions = richText);
                        }
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400, width: 2.0),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: QuillHtmlEditor(
                            text: _instructions ?? '',
                            hintText: 'Adicione instruções aqui!',
                            controller: QuillEditorController(),
                            isEnabled: false,
                            minHeight: 150,
                            hintTextAlign: TextAlign.start,
                            padding: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
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
