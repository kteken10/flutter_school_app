import '../models/class.dart';
import 'class_service.dart';
import 'session_service.dart';
import 'subject_service.dart';
import 'grade_service.dart';
import 'user_service.dart';

import '../models/session.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/user.dart';

class DatabaseService {
  final SessionService _sessionService = SessionService();
  final SubjectService _subjectService = SubjectService();
  final GradeService _gradeService = GradeService();
  final UserService _userService = UserService();
  final ClassService _classService = ClassService();

  /// Récupérer la liste des sessions académiques
  Stream<List<AcademicSession>> getSessions() => _sessionService.getSessions();

  /// Récupérer la liste des matières
  Stream<List<Subject>> getSubjects() => _subjectService.getSubjects();

  /// Récupérer une matière par son ID
  Future<Subject?> getSubjectById(String subjectId) {
    return _subjectService.getSubjectById(subjectId);
  }

  /// Ajouter une matière
  Future<void> addSubject(Subject subject) async {
    await _subjectService.addSubject(subject);
  }

  /// Récupérer les notes d'un étudiant
  Stream<List<Grade>> getStudentGrades(String studentId) {
    return _gradeService.getStudentGrades(studentId);
  }

  /// Ajouter une note (grade)
  Future<void> addGrade(Grade grade) async {
    await _gradeService.addGrade(grade);
  }

  /// Récupérer la liste des étudiants
  Stream<List<UserModel>> getStudents() {
    return _userService.getStudents();
  }

  /// Récupérer la liste des étudiants filtrée par classe (nouvelle méthode)
  Future<List<UserModel>> getStudentsByClass(String classId) async {
    return await _userService.fetchStudentsByClass(classId);
  }

  /// Récupérer un utilisateur par son ID
  Future<UserModel?> getUserById(String userId) {
    return _userService.getUserById(userId);
  }

  /// Récupérer la liste des classes
  Future<List<ClasseModel>> getClasses() async {
    return await _classService.fetchAllClasses();
  }
}
