import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../ui/input_field.dart';

class AdminVerificationModal extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passphraseController = TextEditingController();

  AdminVerificationModal({super.key});

  Future<bool> _verifyAdmin(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      final adminUser = await authService.getUserByEmail(emailController.text.trim());
      if (adminUser?.role != UserRole.admin) {
        throw Exception('Accès réservé aux administrateurs');
      }

      if (!authService.verifyAdminPassphrase(passphraseController.text.trim())) {
        throw Exception('Passphrase incorrecte');
      }
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: const Text(
        'Validation Admin Requise',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Veuillez entrer les identifiants administrateur pour confirmer cette inscription',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            InputField(
              controller: emailController,
              label: 'Email Admin',
              prefixIcon: const Icon(Icons.email, color: AppColors.primary),
              validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 16),
            InputField(
              controller: passphraseController,
              label: 'Passphrase Admin',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
              validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            if (emailController.text.isEmpty || passphraseController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veuillez remplir tous les champs')),
              );
              return;
            }
            final isValid = await _verifyAdmin(context);
            if (isValid) 
            Navigator.pop(context, {
  'email': emailController.text.trim(),
  'passphrase': passphraseController.text.trim(),
});
          },
          child: const Text('Valider', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}