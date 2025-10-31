import 'package:flutter/material.dart';

class SetDurationDialog extends StatefulWidget {
  final Duration initial;
  const SetDurationDialog({super.key, required this.initial});

  @override
  State<SetDurationDialog> createState() => _SetDurationDialogState();
}

class _SetDurationDialogState extends State<SetDurationDialog> {
  late TextEditingController _minController;
  late TextEditingController _secController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final mins = widget.initial.inMinutes;
    final secs = widget.initial.inSeconds.remainder(60);
    _minController = TextEditingController(text: mins.toString());
    _secController = TextEditingController(text: secs.toString());
  }

  @override
  void dispose() {
    _minController.dispose();
    _secController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final mins = int.tryParse(_minController.text) ?? 0;
    final secs = int.tryParse(_secController.text) ?? 0;
    final duration = Duration(minutes: mins, seconds: secs);
    Navigator.of(context).pop(duration);
  }

  String? _validateNumber(String? s) {
    if (s == null || s.isEmpty) return 'Enter a number';
    final v = int.tryParse(s);
    if (v == null || v < 0) return 'Invalid number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quanto tempo?'),
      content: Form(
        key: _formKey,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 90,
              child: TextFormField(
                controller: _minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minutos'),
                validator: _validateNumber,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 90,
              child: TextFormField(
                controller: _secController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Segundos'),
                validator: (s) {
                  final err = _validateNumber(s);
                  if (err != null) return err;
                  final v = int.tryParse(s!)!;
                  if (v >= 60) return '0–59';
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Salvar')),
      ],
    );
  }
}
