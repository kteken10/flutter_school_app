import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/class_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _departmentController = TextEditingController();

  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;
  bool _isLoadingClasses = true;

  List<String> _classNames = [];
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final classes = await ClassService().fetchAllClasses();
    setState(() {
      _classNames = classes.map((c) => c.name).toList();
      _isLoadingClasses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
     
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTitle(),
              const SizedBox(height: 20),
              InputField(
                controller: _firstNameController,
                label: 'Prénom',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Veuillez entrer votre prénom' : null,
              ),
              InputField(
                controller: _lastNameController,
                label: 'Nom',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Veuillez entrer votre nom' : null,
              ),
              InputField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
                  if (!value.contains('@')) return 'Veuillez entrer un email valide';
                  return null;
                },
              ),
              InputField(
                controller: _passwordController,
                label: 'Mot de passe',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Veuillez entrer un mot de passe';
                  if (value.length < 6) return 'Mot de passe trop court';
                  return null;
                },
              ),
              InputField(
                controller: _confirmPasswordController,
                label: 'Confirmer le mot de passe',
                obscureText: true,
                validator: (value) =>
                    value != _passwordController.text ? 'Les mots de passe ne correspondent pas' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                items: UserRole.values.map((role) {
                  return DropdownMenuItem<UserRole>(
                    value: role,
                    child: Text(role.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRole = value!),
                decoration: InputDecoration(
                  labelText: 'Rôle',
                  filled: true,
                  
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedRole == UserRole.student) ...[
                InputField(
                  controller: _studentIdController,
                  label: 'Numéro étudiant',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Veuillez entrer le numéro étudiant' : null,
                ),
                const SizedBox(height: 12),
                _isLoadingClasses
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                        value: _selectedClass,
                        items: _classNames.map((className) {
                          return DropdownMenuItem<String>(
                            value: className,
                            child: Text(className),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedClass = value),
                        decoration: InputDecoration(
                          labelText: 'Classe',
                          filled: true,
                        
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) =>
                            value == null ? 'Veuillez sélectionner une classe' : null,
                      ),
              ],
              if (_selectedRole == UserRole.teacher) ...[
                InputField(
                  controller: _departmentController,
                  label: 'Département',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Veuillez entrer votre département' : null,
                ),
              ],
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: "S'inscrire",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          final user = await authService.registerWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _firstNameController.text.trim(),
                            _lastNameController.text.trim(),
                            _selectedRole,
                            studentId: _selectedRole == UserRole.student
                                ? _studentIdController.text.trim()
                                : null,
                            className: _selectedRole == UserRole.student ? _selectedClass : null,
                            department: _selectedRole == UserRole.teacher
                                ? _departmentController.text.trim()
                                : null,
                          );
                          setState(() => _isLoading = false);

                          if (user != null) {
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Échec de l\'inscription')),
                            );
                          }
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Créez votre compte',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _studentIdController.dispose();
    _departmentController.dispose();
    super.dispose();
  }
}

// Widget personnalisé pour les champs de texte stylisés
class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
       
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
}

// Bouton principal stylisé
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
