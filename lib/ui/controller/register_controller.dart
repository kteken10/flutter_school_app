import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/class_service.dart';
import 'dart:math';
class RegisterController with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController teacherIdController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
final TextEditingController _adminEmailController = TextEditingController();
final TextEditingController _adminPassphraseController = TextEditingController();
  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;
  List<String> _classNames = [];
  String? _selectedClass;

  RegisterController() {
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
    return 'ETD ${random.nextInt(9000) + 1000}';
  }

  String _generateTeacherId() {
    final random = Random();
    final numbers = random.nextInt(900) + 100;
    final letter = String.fromCharCode(random.nextInt(26) + 65);
    return 'ESG $numbers $letter';
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

  Future<bool> register(
    AuthService authService, {
    String? adminEmail,
    String? adminPassphrase,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await authService.registerWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        role: _selectedRole,
        studentId: _selectedRole == UserRole.student
            ? studentIdController.text.trim()
            : null,
        teacherId: _selectedRole == UserRole.teacher
            ? teacherIdController.text.trim()
            : null,
        department: _selectedRole == UserRole.teacher
            ? departmentController.text.trim()
            : null,
        className: _selectedRole == UserRole.student
            ? _selectedClass
            : null,
        adminEmail: adminEmail,
        adminPassphrase: adminPassphrase,
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
    _adminEmailController.dispose();
    _adminPassphraseController.dispose();
    super.dispose();
  }
}