import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'input_decoration.dart';

class RoleDropdown extends StatelessWidget {
  final UserRole? value;
  final ValueChanged<UserRole?> onChanged;

  const RoleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<UserRole>(
      value: value,
      items: UserRole.values.map((role) {
        return DropdownMenuItem<UserRole>(
          value: role,
          child: Text(
            role.toString().split('.').last,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecorations.standard('Rôle', Icons.person_outline),
      validator: (value) =>
          value == null ? 'Veuillez sélectionner un rôle' : null,
    );
  }
}

class ClassDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> classes;
  final ValueChanged<String?> onChanged;
  final bool isLoading;
  final String? errorText;

  const ClassDropdown({
    super.key,
    required this.selectedValue,
    required this.classes,
    required this.onChanged,
    this.isLoading = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecorations.standard('Classe', Icons.class_),
          items: [
            const DropdownMenuItem<String>(
            
              value: null,
              child: Text(
                'Sélectionnez une classe',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ...classes.map(
              (className) => DropdownMenuItem<String>(
                value: className,
                child: Text(className),
              ),
            ),
          ],
          onChanged: isLoading ? null : onChanged,
          validator: (value) =>
              value == null ? 'Ce champ est obligatoire' : null,
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: LinearProgressIndicator(
              minHeight: 2,
              color: Colors.blue,
            ),
          ),
      ],
    );
  }
}
