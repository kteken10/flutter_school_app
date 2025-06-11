import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../ui/teacher_card_deco.dart';
import 'register_screen.dart';
import '../../constants/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

InputDecoration _inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.textSecondary.withOpacity(0.2),size: 22),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.white),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
    backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/academic_logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 16),
               const TeacherCardDeco(imagePath: 'assets/login_school.jpg', withHorizontalMargin: false,),
                const SizedBox(height: 30),
                Text(
                  'Bienvenu sur !',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
               
                const SizedBox(height: 8),
                Text(
                  ' Votre plateforme de gestion de note optimisée',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                         decoration: _inputDecoration('Email', Icons.email),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            if (!value.contains('@')) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: _inputDecoration('Mot de passe', Icons.lock),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    final user = authService.signInWithEmailAndPassword(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                    setState(() => _isLoading = false);

                                    if (user == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Échec de la connexion')),
                                      );
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterScreen()),
                              );
                            },
                            child: Text(
                              'Créer un compte',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 20),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Fonctionnalité à implémenter')),
                              );
                            },
                            child: Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
