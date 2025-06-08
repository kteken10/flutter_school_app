import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/class_service.dart';

class RegisterController with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController teacherIdController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;
  List<String> _classNames = [];
  String? _selectedClass;

  RegisterController() {
    // Générer les IDs automatiquement à la création du contrôleur
    _generateIds();
  }

  // Getters
  UserRole get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  List<String> get classNames => _classNames;
  String? get selectedClass => _selectedClass;

  // Méthodes pour générer les IDs
  void _generateIds() {
    studentIdController.text = _generateStudentId();
    teacherIdController.text = _generateTeacherId();
  }

  String _generateStudentId() {
    final random = Random();
    return 'ETD ${random.nextInt(9000) + 1000}'; // ETD + 4 chiffres (1000-9999)
  }

  String _generateTeacherId() {
    final random = Random();
    final numbers = random.nextInt(900) + 100; // 3 chiffres (100-999)
    final letter = String.fromCharCode(random.nextInt(26) + 65); // Lettre majuscule
    return 'ESG $numbers $letter'; // Format: ESG 123 A
  }

  Future<void> loadClasses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final classes = await ClassService().fetchAllClasses();
      _classNames = classes.map((c) => c.name).toList();
    } catch (e) {
      _classNames = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setClass(String? className) {
    _selectedClass = className;
    notifyListeners();
  }

  Future<bool> register(AuthService authService) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await authService.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        _selectedRole,
        studentId: _selectedRole == UserRole.student
            ? studentIdController.text.trim()
            : null,
        teacherId: _selectedRole == UserRole.teacher
            ? teacherIdController.text.trim()
            : null,
        className: _selectedRole == UserRole.student
            ? _selectedClass
            : null,
        department: _selectedRole == UserRole.teacher
            ? departmentController.text.trim()
            : null,
      );
      return user != null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    studentIdController.dispose();
    teacherIdController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}