# schoop_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
a527f962-8c4d-4743-af2a-c4794077c81a



  final List<UserModel> _students = [
    UserModel(
      id: 's1',
      firstName: 'Alice',
      lastName: 'Ngoua',
      email: 'alice@example.com',
      role: UserRole.student,
      className: 'L1',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's2',
      firstName: 'Brice',
      lastName: 'Yaoundé',
      email: 'brice@example.com',
      role: UserRole.student,
      className: 'L2',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's3',
      firstName: 'Chantal',
      lastName: 'Bafoussam',
      email: 'chantal@example.com',
      role: UserRole.student,
      className: 'L3',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's4',
      firstName: 'David',
      lastName: 'Douala',
      email: 'david@example.com',
      role: UserRole.student,
      className: 'M1',
      createdAt: DateTime(2023, 9, 1),
    ),
    UserModel(
      id: 's5',
      firstName: 'Eva',
      lastName: 'Garoua',
      email: 'eva@example.com',
      role: UserRole.student,
      className: 'M2',
      createdAt: DateTime(2023, 9, 1),
    ),
  ];

  

  // Structure de données plus complète pour gérer les notes par matière et session
  final Map<String, Map<String, Map<String, double>>> _studentGrades = {
    's1': {
      'Mathématiques': {'Session 1': 12.0, 'Session 2': 14.0},
      'Informatique': {'Session 1': 15.5, 'Session 2': 16.0},
    },
    's2': {
      'Base de données': {'Session 1': 8.0, 'Session 2': 10.5},
      'Machine Learning': {'Session 1': 14.0},
    },
    's3': {
      'Linux': {'Session 1': 15.0, 'Session 2': 13.5},
      'Réseaux': {'Session 1': 17.0},
    },
    's4': {
      'IA': {'Session 1': 16.0, 'Session 2': 18.0},
      'Big Data': {'Session 1': 14.0},
    },
    's5': {
      'Cloud Computing': {'Session 1': 18.0, 'Session 2': 19.5},
      'DevOps': {'Session 1': 17.5},
    },
  };