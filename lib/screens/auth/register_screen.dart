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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late RegisterController _registerController;
  int _formStep = 0; // 0 = infos perso, 1 = sécurité + rôle

  @override
  void initState() {
    super.initState();
    _registerController = RegisterController();
    _registerController.loadClasses();
  }

  @override
  void dispose() {
    _registerController.dispose();
    super.dispose();
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
                  imagePath: 'assets/registerd_school.jpg',
                  withHorizontalMargin: true,
                ),
                const SizedBox(height: 16),

                // Toggle buttons
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
                              prefixIcon:  Icon(Icons.person,  color: Colors.grey[300],size: 22,),
                              keyboardType: TextInputType.name,
                            ),
                            InputField(
                              controller: controller.lastNameController,
                              label: 'Nom',
                              prefixIcon: Icon(Icons.person,  color: Colors.grey[300],size: 22,),
                              keyboardType: TextInputType.name,
                            ),
                            InputField(
                              controller: controller.emailController,
                              label: 'Email',
                              prefixIcon:  Icon(Icons.email,  color: Colors.grey[300],size: 22),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ] else if (_formStep == 1) ...[
                            InputField(
                              controller: controller.passwordController,
                              label: 'Mot de passe',
                              prefixIcon:  Icon(Icons.lock,  color: Colors.grey[300],size: 22),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                            InputField(
                              controller: controller.confirmPasswordController,
                              label: 'Confirmer le mot de passe',
                              prefixIcon:  Icon(Icons.lock,  color: Colors.grey[300],size: 22,),
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
                                prefixIcon:  Icon(Icons.badge, color: Colors.grey[300],size: 22,),
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
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ],

                          const SizedBox(height: 30),
                          controller.isLoading
                              ? const CircularProgressIndicator()
                              : PrimaryButton(
                                  text: "S'inscrire",
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final success = await controller.register(authService);
                                      if (success) {
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Échec de l\'inscription'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
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
