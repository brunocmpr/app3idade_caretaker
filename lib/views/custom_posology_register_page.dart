import 'package:app3idade_caretaker/models/custom_posology.dart';
import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/drug_plan_service.dart';
import 'package:app3idade_caretaker/util/util.dart';
import 'package:app3idade_caretaker/widgets/datetime_picker.dart';
import 'package:flutter/material.dart';

class CustomPosologyRegisterPage extends StatefulWidget {
  const CustomPosologyRegisterPage({super.key, required this.drugPlan});
  final DrugPlan drugPlan;
  @override
  State<CustomPosologyRegisterPage> createState() => CustomPosologyRegisterPageState();
}

class CustomPosologyRegisterPageState extends State<CustomPosologyRegisterPage> {
  final List<DateTime> _dateTimes = List.empty(growable: true);
  final _drugPlanService = DrugPlanService();

  void _onDateTimeChanged(DateTime newDate) {
    if (_dateTimes.contains(newDate)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data e hora já registrados')));
      return;
    }
    setState(() {
      _dateTimes.add(newDate);
      _dateTimes.sort((a, b) => a.compareTo(b));
    });
  }

  Future<void> _submit() async {
    if (_dateTimes.isEmpty) {
      return;
    }
    var customPosologies = _dateTimes.map((date) => CustomPosology.newPosology(date)).toList();
    widget.drugPlan.customPosologies = customPosologies;
    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      await _drugPlanService.createDrugPlan(widget.drugPlan);
      navigator.popUntil(ModalRoute.withName(Routes.homePage));
      messenger.showSnackBar(
        const SnackBar(content: Text("Tratamento criado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    }
  }

  _removeDate(DateTime dateTime) {
    setState(() {
      _dateTimes.remove(dateTime);
    });
  }

  Widget _buildDateDisplay(DateTime date) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(formatDateTime(date)),
            ElevatedButton(onPressed: () => _removeDate(date), child: const Text('Remover'))
          ],
        ),
        const SizedBox(height: 8)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dateComponents = _dateTimes.map(_buildDateDisplay).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo cronograma uniforme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
                'Tratamento de ${widget.drugPlan.drug.nameAndStrength} para ${widget.drugPlan.patient.preferredName}.'),
            const SizedBox(height: 8),
            DateTimePicker(label: 'Adicionar data e hora', onDateTimeChanged: _onDateTimeChanged),
            const SizedBox(height: 8),
            Text('${_dateTimes.length} data${_dateTimes.length == 1 ? '' : 's'} selecionadas'),
            const SizedBox(height: 8),
            Column(
              children: dateComponents,
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: isReadyToSubmit ? _submit : null, child: const Text('Criar'))
          ],
        ),
      ),
    );
  }

  bool get isReadyToSubmit => _dateTimes.isNotEmpty;
}
