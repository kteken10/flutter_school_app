import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../ui/button.dart';
import '../../ui/controller/register_controller.dart';
import '../../ui/form_components.dart';
import '../../ui/teacher_card_deco.dart';
import '../../ui/input_field.dart';
import '../../ui/verification_modal.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late RegisterController _registerController;
  int _formStep = 0;
  final TextEditingController _adminEmailController = TextEditingController();
  final TextEditingController _adminPassphraseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _registerController = RegisterController();
    _registerController.loadClasses();
  }

  @override
  void dispose() {
    _registerController.dispose();
    _adminEmailController.dispose();
    _adminPassphraseController.dispose();
    super.dispose();
  }

  Future<bool> _showAdminVerification(BuildContext context) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AdminVerificationModal(),
    );

    if (result != null) {
      _adminEmailController.text = result['email']!;
      _adminPassphraseController.text = result['passphrase']!;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ChangeNotifierProvider.value(
        value: _registerController,
        child: Consumer<RegisterController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                const SizedBox(height: 32),
                const Center(
                  child: Image(
                    image: AssetImage('assets/academic_logo.png'),
                    height: 100,
                  ),
                ),
                const SizedBox(height: 16),
                const TeacherCardDeco(
                 
                  imagePaths: ['assets/registerd_school.jpg'],

                  withHorizontalMargin: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Informations personnelles'),
                      selected: _formStep == 0,
                      onSelected: (_) => setState(() => _formStep = 0),
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('Sécurité et rôle'),
                      selected: _formStep == 1,
                      onSelected: (_) => setState(() => _formStep = 1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_formStep == 0) ...[
                            InputField(
                              controller: controller.firstNameController,
                              label: 'Prénom',
                              prefixIcon: Icon(Icons.person, color: Colors.grey[300], size: 22),
                              validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
                              keyboardType: TextInputType.name,
                            ),
                            InputField(
                              controller: controller.lastNameController,
                              label: 'Nom',
                              prefixIcon: Icon(Icons.person, color: Colors.grey[300], size: 22),
                              validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
                              keyboardType: TextInputType.name,
                            ),
                            InputField(
                              controller: controller.emailController,
                              label: 'Email',
                              prefixIcon: Icon(Icons.email, color: Colors.grey[300], size: 22),
                              validator: (value) =>
                                  value!.isEmpty ? 'Ce champ est requis' : !value.contains('@') ? 'Email invalide' : null,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ] else if (_formStep == 1) ...[
                            InputField(
                              controller: controller.passwordController,
                              label: 'Mot de passe',
                              prefixIcon: Icon(Icons.lock, color: Colors.grey[300], size: 22),
                              validator: (value) =>
                                  value!.isEmpty ? 'Ce champ est requis' : value.length < 6 ? 'Minimum 6 caractères' : null,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            RoleDropdown(
                              value: controller.selectedRole,
                              onChanged: (UserRole? newRole) {
                                if (newRole != null) {
                                  controller.setRole(newRole);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            if (controller.selectedRole == UserRole.student) ...[
                              InputField(
                                controller: controller.studentIdController,
                                label: 'Numéro étudiant',
                                prefixIcon: Icon(Icons.badge, color: Colors.grey[300], size: 22),
                                enabled: false,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 12),
                              ClassDropdown(
                                selectedValue: controller.selectedClass,
                                classes: controller.classNames,
                                onChanged: controller.setClass,
                                isLoading: controller.isLoading,
                              ),
                            ],
                            if (controller.selectedRole == UserRole.teacher) ...[
                              InputField(
                                controller: controller.departmentController,
                                label: 'Département',
                                prefixIcon: const Icon(Icons.account_balance, color: Colors.grey),
                                validator: (value) =>
                                    controller.selectedRole == UserRole.teacher && value!.isEmpty
                                        ? 'Ce champ est requis'
                                        : null,
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ],
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              if (_formStep > 0)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => setState(() => _formStep--),
                                    child: const Text('Retour'),
                                  ),
                                ),
                              if (_formStep > 0) const SizedBox(width: 16),
                              Expanded(
                                child: controller.isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : PrimaryButton(
                                        text: _formStep == 0 ? 'Continuer' : 'Inscrire',
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            if (_formStep == 0) {
                                              setState(() => _formStep++);
                                            } else {
                                              bool isAdminVerified = true;
                                              if (controller.selectedRole != UserRole.admin) {
                                                isAdminVerified = await _showAdminVerification(context);
                                              }
                                              if (isAdminVerified) {
                                                final success = await controller.register(
                                                  authService,
                                                  adminEmail: _adminEmailController.text.trim(),
                                                  adminPassphrase: _adminPassphraseController.text.trim(),
                                                );
                                                if (success) {
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                } else {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Échec de l\'inscription')),
                                                    );
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        },
                                      ),
                              ),
                            ],
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
