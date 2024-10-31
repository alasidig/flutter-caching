import 'package:flutter/material.dart';

class AddNameForm extends StatelessWidget {
  AddNameForm({super.key, required this.label, required this.onSubmit});

  final String label;
  final void Function(String) onSubmit;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
      trailing: IconButton(
        onPressed: () => onSubmit(controller.text),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
