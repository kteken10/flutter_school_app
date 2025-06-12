import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../data/dummy_grade.dart';
import '../../models/user.dart';
import '../../ui/grade_entry_dialog.dart';
import '../../ui/student_card.dart';
import '../../ui/search_zone.dart';
import '../../ui/teacher_card.dart';
import '../../ui/teacher_card_deco.dart';

import '../../ui/class_filter.dart';
import '../../ui/subject_filter.dart';
import '../../ui/session_filter.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);
  final int totalStudentImages = 3;

  String? selectedYear;
  String? selectedClass;
  String? selectedSubject;
  String? selectedSession;

  final List<String> availableYears = ['2023-2024', '2022-2023'];
  late List<String> _allSubjects;
  final List<String> _allSessions = ['Contrôle Continu', 'Session Normale'];
  late List<String> _classes=['L1','L2',"L3"];
  
  late List<UserModel> _students;

  late Map<String, Map<String, Map<String, double>>> _studentGrades;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year.toString();
    _searchController.addListener(_onSearchChanged);
    _loadLocalData();
  }

void _onAddNote() {
    showDialog(
      context: context,
      builder: (context) => GradeEntryDialog(
        onGradeSubmitted: () => setState(() {}),
      ),
    );
  }
  Future<void> _loadLocalData() async {
  setState(() => isLoading = true);

  _students = [
    UserModel(
      id: 'stu1',
      firstName: 'Lucas',
      lastName: 'Martin',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'lucas.martin@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1001',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu2',
      firstName: 'Emma',
      lastName: 'Bernard',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'emma.bernard@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1002',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu3',
      firstName: 'Hugo',
      lastName: 'Dubois',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'hugo.dubois@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1003',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu4',
      firstName: 'Chloé',
      lastName: 'Thomas',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'chloe.thomas@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1004',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu5',
      firstName: 'Louis',
      lastName: 'Robert',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'louis.robert@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1005',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu6',
      firstName: 'Léa',
      lastName: 'Richard',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'lea.richard@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1006',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu7',
      firstName: 'Gabriel',
      lastName: 'Petit',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'gabriel.petit@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1007',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu8',
      firstName: 'Manon',
      lastName: 'Durand',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'manon.durand@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1008',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu9',
      firstName: 'Jules',
      lastName: 'Leroy',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'jules.leroy@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1009',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu10',
      firstName: 'Camille',
      lastName: 'Moreau',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'camille.moreau@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1010',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu11',
      firstName: 'Nathan',
      lastName: 'Simon',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'nathan.simon@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1011',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu12',
      firstName: 'Sarah',
      lastName: 'Laurent',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'sarah.laurent@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1012',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu13',
      firstName: 'Thomas',
      lastName: 'Michel',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'thomas.michel@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1013',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu14',
      firstName: 'Inès',
      lastName: 'Garcia',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'ines.garcia@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1014',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu15',
      firstName: 'Maxime',
      lastName: 'David',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'maxime.david@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1015',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu16',
      firstName: 'Clara',
      lastName: 'Bertrand',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'clara.bertrand@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1016',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu17',
      firstName: 'Raphaël',
      lastName: 'Roux',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'raphael.roux@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1017',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu18',
      firstName: 'Zoé',
      lastName: 'Vincent',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'zoe.vincent@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1018',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu19',
      firstName: 'Antoine',
      lastName: 'Fournier',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'antoine.fournier@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1019',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
    UserModel(
      id: 'stu20',
      firstName: 'Julie',
      lastName: 'Morel',
      createdAt: DateTime.parse('2022-02-16T00:00:00'),
      email: 'julie.morel@univ-example.com',
      role: UserRole.student,
      className: 'L3',
      photoUrl: '',
      assignedClassIds: [],
      taughtSubjectIds: [],
      createdBy: 'admin3',
      department: 'Informatique',
      studentId: 'S1020',
      teacherId: 'T001',
      lastAdminAction: DateTime.parse('2025-03-18T00:00:00'),
      isActive: true,
      isSuperAdmin: false,
    ),
  ];

  _allSubjects = [
    'Linux',
    'Base de données',
    'Algorithmique',
    'Développement Web',
    'Développement Mobile',
    'Réseaux',
    'Cloud Computing',
    'DevOps',
    'Intelligence Artificielle',
    'Machine Learning',
  ];


   _studentGrades = {
  'stu1': {
    'Algorithmique': {'Contrôle Continu': 17, 'Session Normale': 12},
    'Cloud Computing': {'Contrôle Continu': 11, 'Session Normale': 14},
    'DevOps': {'Contrôle Continu': 12, 'Session Normale': 12},
    'Linux': {'Contrôle Continu': 10, 'Session Normale': 18},
    'Machine Learning': {'Contrôle Continu': 17, 'Session Normale': 17}
  },
  'stu2': {
    'Algorithmique': {'Contrôle Continu': 15, 'Session Normale': 14},
    'Base de données': {'Contrôle Continu': 12, 'Session Normale': 13},
    'Développement Mobile': {'Contrôle Continu': 16, 'Session Normale': 15},
    'Linux': {'Contrôle Continu': 14, 'Session Normale': 16},
    'Réseaux': {'Contrôle Continu': 13, 'Session Normale': 12}
  },
  'stu3': {
    'Algorithmique': {'Contrôle Continu': 18, 'Session Normale': 16},
    'Cloud Computing': {'Contrôle Continu': 15, 'Session Normale': 14},
    'Développement Web': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Intelligence Artificielle': {'Contrôle Continu': 16, 'Session Normale': 17},
    'Machine Learning': {'Contrôle Continu': 15, 'Session Normale': 16}
  },
  'stu4': {
    'Base de données': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Développement Web': {'Contrôle Continu': 12, 'Session Normale': 14},
    'Réseaux': {'Contrôle Continu': 16, 'Session Normale': 17},
    'DevOps': {'Contrôle Continu': 13, 'Session Normale': 14},
    'Intelligence Artificielle': {'Contrôle Continu': 15, 'Session Normale': 16}
  },
  'stu5': {
    'Algorithmique': {'Contrôle Continu': 9, 'Session Normale': 11},
    'Linux': {'Contrôle Continu': 12, 'Session Normale': 14},
    'Développement Mobile': {'Contrôle Continu': 15, 'Session Normale': 13},
    'Cloud Computing': {'Contrôle Continu': 10, 'Session Normale': 12},
    'Machine Learning': {'Contrôle Continu': 14, 'Session Normale': 15}
  },
  'stu6': {
    'Développement Web': {'Contrôle Continu': 17, 'Session Normale': 16},
    'Base de données': {'Contrôle Continu': 15, 'Session Normale': 14},
    'Réseaux': {'Contrôle Continu': 13, 'Session Normale': 15},
    'DevOps': {'Contrôle Continu': 16, 'Session Normale': 17},
    'Intelligence Artificielle': {'Contrôle Continu': 18, 'Session Normale': 16}
  },
  'stu7': {
    'Algorithmique': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Cloud Computing': {'Contrôle Continu': 12, 'Session Normale': 13},
    'Développement Mobile': {'Contrôle Continu': 11, 'Session Normale': 12},
    'Linux': {'Contrôle Continu': 13, 'Session Normale': 14},
    'Machine Learning': {'Contrôle Continu': 15, 'Session Normale': 16}
  },
  'stu8': {
    'Base de données': {'Contrôle Continu': 16, 'Session Normale': 17},
    'Développement Web': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Réseaux': {'Contrôle Continu': 12, 'Session Normale': 13},
    'DevOps': {'Contrôle Continu': 15, 'Session Normale': 16},
    'Intelligence Artificielle': {'Contrôle Continu': 17, 'Session Normale': 18}
  },
  'stu9': {
    'Algorithmique': {'Contrôle Continu': 11, 'Session Normale': 13},
    'Linux': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Développement Mobile': {'Contrôle Continu': 12, 'Session Normale': 14},
    'Cloud Computing': {'Contrôle Continu': 13, 'Session Normale': 12},
    'Machine Learning': {'Contrôle Continu': 15, 'Session Normale': 14}
  },
  'stu10': {
    'Développement Web': {'Contrôle Continu': 16, 'Session Normale': 15},
    'Base de données': {'Contrôle Continu': 14, 'Session Normale': 13},
    'Réseaux': {'Contrôle Continu': 15, 'Session Normale': 16},
    'DevOps': {'Contrôle Continu': 12, 'Session Normale': 14},
    'Intelligence Artificielle': {'Contrôle Continu': 13, 'Session Normale': 15}
  },
  'stu11': {
    'Algorithmique': {'Contrôle Continu': 17, 'Session Normale': 16},
    'Cloud Computing': {'Contrôle Continu': 15, 'Session Normale': 14},
    'Développement Mobile': {'Contrôle Continu': 16, 'Session Normale': 17},
    'Linux': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Machine Learning': {'Contrôle Continu': 18, 'Session Normale': 17}
  },
  'stu12': {
    'Base de données': {'Contrôle Continu': 13, 'Session Normale': 14},
    'Développement Web': {'Contrôle Continu': 12, 'Session Normale': 11},
    'Réseaux': {'Contrôle Continu': 14, 'Session Normale': 15},
    'DevOps': {'Contrôle Continu': 11, 'Session Normale': 13},
    'Intelligence Artificielle': {'Contrôle Continu': 15, 'Session Normale': 14}
  },
  'stu13': {
    'Algorithmique': {'Contrôle Continu': 14, 'Session Normale': 16},
    'Linux': {'Contrôle Continu': 12, 'Session Normale': 13},
    'Développement Mobile': {'Contrôle Continu': 15, 'Session Normale': 14},
    'Cloud Computing': {'Contrôle Continu': 13, 'Session Normale': 15},
    'Machine Learning': {'Contrôle Continu': 16, 'Session Normale': 17}
  },
  'stu14': {
    'Développement Web': {'Contrôle Continu': 18, 'Session Normale': 17},
    'Base de données': {'Contrôle Continu': 16, 'Session Normale': 15},
    'Réseaux': {'Contrôle Continu': 14, 'Session Normale': 16},
    'DevOps': {'Contrôle Continu': 15, 'Session Normale': 17},
    'Intelligence Artificielle': {'Contrôle Continu': 17, 'Session Normale': 18}
  },
  'stu15': {
    'Algorithmique': {'Contrôle Continu': 12, 'Session Normale': 14},
    'Cloud Computing': {'Contrôle Continu': 10, 'Session Normale': 12},
    'Développement Mobile': {'Contrôle Continu': 13, 'Session Normale': 14},
    'Linux': {'Contrôle Continu': 11, 'Session Normale': 13},
    'Machine Learning': {'Contrôle Continu': 14, 'Session Normale': 15}
  },
  'stu16': {
    'Base de données': {'Contrôle Continu': 15, 'Session Normale': 16},
    'Développement Web': {'Contrôle Continu': 13, 'Session Normale': 14},
    'Réseaux': {'Contrôle Continu': 12, 'Session Normale': 13},
    'DevOps': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Intelligence Artificielle': {'Contrôle Continu': 16, 'Session Normale': 15}
  },
  'stu17': {
    'Algorithmique': {'Contrôle Continu': 16, 'Session Normale': 15},
    'Linux': {'Contrôle Continu': 14, 'Session Normale': 13},
    'Développement Mobile': {'Contrôle Continu': 15, 'Session Normale': 16},
    'Cloud Computing': {'Contrôle Continu': 12, 'Session Normale': 14},
    'Machine Learning': {'Contrôle Continu': 17, 'Session Normale': 16}
  },
  'stu18': {
    'Développement Web': {'Contrôle Continu': 14, 'Session Normale': 15},
    'Base de données': {'Contrôle Continu': 12, 'Session Normale': 13},
    'Réseaux': {'Contrôle Continu': 15, 'Session Normale': 16},
    'DevOps': {'Contrôle Continu': 13, 'Session Normale': 14},
    'Intelligence Artificielle': {'Contrôle Continu': 16, 'Session Normale': 15}
  },
  'stu19': {
    'Algorithmique': {'Contrôle Continu': 18, 'Session Normale': 17},
    'Cloud Computing': {'Contrôle Continu': 16, 'Session Normale': 15},
    'Développement Mobile': {'Contrôle Continu': 17, 'Session Normale': 18},
    'Linux': {'Contrôle Continu': 15, 'Session Normale': 16},
    'Machine Learning': {'Contrôle Continu': 19, 'Session Normale': 18}
  },
  'stu20': {
    'Base de données': {'Contrôle Continu': 11, 'Session Normale': 12},
    'Développement Web': {'Contrôle Continu': 13, 'Session Normale': 14},
    'Réseaux': {'Contrôle Continu': 10, 'Session Normale': 11},
    'DevOps': {'Contrôle Continu': 12, 'Session Normale': 13},
    'Intelligence Artificielle': {'Contrôle Continu': 14, 'Session Normale': 15}
  },
};
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => isLoading = false);
  }

  void _onSearchChanged() => setState(() {});

  List<UserModel> _filterStudents(String searchText) {
    List<UserModel> filtered = _students;

    if (selectedClass != null) {
      filtered = filtered.where((s) => s.className == selectedClass).toList();
    }

    if (searchText.isNotEmpty) {
      filtered = filtered.where((s) {
        final name = s.fullName.toLowerCase();
        final q = searchText.toLowerCase();
        return name.contains(q) ||
            s.firstName.toLowerCase().contains(q) ||
            s.lastName.toLowerCase().contains(q);
      }).toList();
    }

    if (selectedTab.value == 2 && selectedSubject != null) {
      filtered = filtered.where((s) {
        final gradesBySubject = _studentGrades[s.id];
        return gradesBySubject?.containsKey(selectedSubject!) ?? false;
      }).toList();
    }

    if (selectedTab.value == 0 && selectedSession != null) {
      filtered = filtered.where((s) {
        final gradesBySubject = _studentGrades[s.id];
        if (gradesBySubject == null) return false;
        return gradesBySubject.values.any((sessions) => sessions.containsKey(selectedSession));
      }).toList();
    }

    return filtered;
  }

  List<String> _getSubjectsForStudent(String studentId) {
    final gradesBySubject = _studentGrades[studentId];
    if (gradesBySubject == null) return [];
    if (selectedSubject != null) {
      return gradesBySubject.containsKey(selectedSubject!) ? [selectedSubject!] : [];
    }
    return gradesBySubject.keys.toList();
  }

  

  List<double> _getGradesForStudentAndSubjects(String studentId, List<String> subjects) {
    final gradesBySubject = _studentGrades[studentId];
    if (gradesBySubject == null) return [];

    List<double> grades = [];
    for (var subject in subjects) {
      final sessions = gradesBySubject[subject];
      if (sessions == null) continue;

      if (selectedSession != null) {
        final grade = sessions[selectedSession!];
        if (grade != null) grades.add(grade);
      } else {
        grades.addAll(sessions.values);
      }
    }
    return grades;
  }

  double _calculateAverage(String studentId) {
    final allGrades = _getGradesForStudentAndSubjects(studentId, _getSubjectsForStudent(studentId));
    if (allGrades.isEmpty) return 0.0;
    final sum = allGrades.reduce((a, b) => a + b);
    return sum / allGrades.length;
  }

  String _getStudentImageAsset(int index) {
    final imageNumber = (index % totalStudentImages) + 1;
    return 'assets/student_$imageNumber.png';
  }

  String _getNoResultsMessage() {
    if (selectedClass != null) return "Aucun étudiant dans la classe $selectedClass";
    if (selectedSubject != null) return "Aucun étudiant n'a de notes en $selectedSubject";
    if (selectedSession != null) return "Aucun étudiant dans la session $selectedSession";
    if (_searchController.text.isNotEmpty) return "Aucun étudiant trouvé";
    return "Aucun étudiant disponible";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TeacherCard(
                    name: name,
                    email: email,
                    profileImageUrl: profileImageUrl,
                    subjectCount: subjectCount,
                    classCount: classCount,
                    subjects: subjects,
                    classes: classes,
                    onAddPressed:  _onAddNote,
                  ),
                  const SizedBox(height: 16),
                  TeacherCardDeco(imagePaths: ['assets/registerd_school.jpg', 'assets/student_black.jpg']),
                  const SizedBox(height: 16),
                  SearchZone(controller: _searchController),
                  const SizedBox(height: 8),
                  ClassFilter(
                    classes: _classes,
                    selectedClass: selectedClass,
                    onClassSelected: (val) => setState(() => selectedClass = val),
                  ),
                  SubjectFilter(
                    subjects: _allSubjects,
                    selectedSubject: selectedSubject,
                    onSubjectSelected: (val) => setState(() => selectedSubject = val),
                  ),
                  SessionFilter(
                    sessions: _allSessions,
                    selectedSession: selectedSession,
                    onSessionSelected: (val) => setState(() => selectedSession = val),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: screenHeight * 0.5,
                    child: ValueListenableBuilder<int>(
                      valueListenable: selectedTab,
                      builder: (context, tabIndex, _) {
                        final filteredStudents = _filterStudents(_searchController.text);
              
                        if (filteredStudents.isEmpty) {
                          return Center(
                            child: Text(
                              _getNoResultsMessage(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }
              
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
                            final avg = _calculateAverage(student.id);
                            final imageAsset = _getStudentImageAsset(index);
              
                            final subjects = _getSubjectsForStudent(student.id);
                            final grades = _getGradesForStudentAndSubjects(student.id, subjects);
              
                            return StudentCard(
                              studentName: student.fullName,
                              studentClass: student.className ?? 'N/A',
                              studentPhotoAsset: imageAsset,
                              subjectNames: subjects,
                              subjectGrades: grades,
                              progress: avg / 20.0,
                              onProfileTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Profil de ${student.fullName}')),
                                );
                              },
                            );
                          },
                        );



                        
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
