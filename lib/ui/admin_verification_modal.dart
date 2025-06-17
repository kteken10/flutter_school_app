import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../ui/input_field.dart';

class AdminVerificationModal extends StatefulWidget {
  const AdminVerificationModal({super.key});

  @override
  State<AdminVerificationModal> createState() => _AdminVerificationModalState();
}

class _AdminVerificationModalState extends State<AdminVerificationModal> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passphraseController = TextEditingController();
  bool obscureText = true;

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
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.all(0),
      title: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.secondary.withOpacity(0.1),
            child: const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 30),
          ),
          const SizedBox(height: 12),
          const Text(
            'Validation de Sécurité',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Pour continuer, une "),
                    TextSpan(
                      text: "confirmation d'identité administrateur",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " est requise."),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              controller: emailController,
              label: 'Email Administrateur',
              prefixIcon: const Icon(Icons.email, color: AppColors.secondary),
              validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 16),
            InputField(
              controller: passphraseController,
              label: 'Passphrase Sécurisée',
              obscureText: obscureText,
              prefixIcon: const Icon(Icons.lock, color: AppColors.secondary),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.secondary,
                ),
                onPressed: () => setState(() => obscureText = !obscureText),
              ),
              validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.verified, size: 18 ,color: Colors.white,),
          label: const Text('Confirmer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          
          onPressed: () async {
            if (emailController.text.isEmpty || passphraseController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veuillez remplir tous les champs')),
              );
              return;
            }
            final isValid = await _verifyAdmin(context);
            if (isValid) {
              Navigator.pop(context, {
                'email': emailController.text.trim(),
                'passphrase': passphraseController.text.trim(),
              });
            }
          },
        ),
      ],
    );
  }
}
