import '../models/grade.dart';
import '../models/session.dart';
import '../models/subject.dart';
import '../models/user.dart';

final List<Grade> dummyGrades = [
  Grade(
    id: 'g1',
    studentId: 's1',
    subjectId: 'sub1',
    sessionId: 'session1',
    status: GradeStatus.published,
    classId: 'class1',
    teacherId: 't1',
    value: 14,
    sessionType: ExamSessionType.controleContinu,
    comment: 'Bonne maîtrise des commandes de base',
    dateRecorded: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Grade(
    id: 'g2',
    studentId: 's1',
    subjectId: 'sub2',
    sessionId: 'session2',
    status: GradeStatus.published,
    classId: 'class1',
    teacherId: 't2',
    value: 16.5,
    sessionType: ExamSessionType.controleContinu,
    comment: 'Requêtes SQL bien maîtrisées',
    dateRecorded: DateTime.now().subtract(const Duration(days: 12)),
  ),
  Grade(
    id: 'g3',
    studentId: 's1',
    subjectId: 'sub3',
    sessionId: 'session3',
    status: GradeStatus.published,
    classId: 'class1',
    teacherId: 't3',
    value: 18,
    sessionType: ExamSessionType.controleContinu,
    comment: 'Très bon projet IA',
    dateRecorded: DateTime.now().subtract(const Duration(days: 20)),
  ),
  Grade(
    id: 'g4',
    studentId: 's1',
    subjectId: 'sub4',
    sessionId: 'session4',
    status: GradeStatus.published,
    classId: 'class1',
    teacherId: 't1',
    value: 15.5,
    sessionType: ExamSessionType.sessionNormale,
    comment: 'Modèles bien entraînés',
    dateRecorded: DateTime.now().subtract(const Duration(days: 25)),
  ),
  Grade(
    id: 'g5',
    studentId: 's1',
    subjectId: 'sub5',
    sessionId: 'session5',
    status: GradeStatus.published,
    classId: 'class1',
    teacherId: 't2',
    value: 17,
    sessionType: ExamSessionType.controleContinu,
    comment: 'Bonne configuration des protocoles',
    dateRecorded: DateTime.now().subtract(const Duration(days: 8)),
  ),
];

final Map<String, Subject> dummySubjects = {
  'sub1': Subject(id: 'sub1', name: 'Systèmes Linux', code: 'LINUX201', department: 'Informatique', credit: 3),
  'sub2': Subject(id: 'sub2', name: 'Bases de Données', code: 'BD202', department: 'Informatique', credit: 4),
  'sub3': Subject(id: 'sub3', name: 'Intelligence Artificielle', code: 'IA301', department: 'Informatique', credit: 5),
  'sub4': Subject(id: 'sub4', name: 'Machine Learning', code: 'ML302', department: 'Informatique', credit: 5),
  'sub5': Subject(id: 'sub5', name: 'Réseaux Informatiques', code: 'NET203', department: 'Informatique', credit: 3),
};

final Map<String, UserModel> dummyTeachers = {
  't1': UserModel(
    id: 't1',
    firstName: 'Mme',
    lastName: 'Dupont',
    email: 'dupont@ecole.com',
    role: UserRole.teacher,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  ),
  't2': UserModel(
    id: 't2',
    firstName: 'M.',
    lastName: 'Martin',
    email: 'martin@ecole.com',
    role: UserRole.teacher,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  ),
  't3': UserModel(
    id: 't3',
    firstName: 'Mme',
    lastName: 'Bernard',
    email: 'bernard@ecole.com',
    role: UserRole.teacher,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  ),
};
