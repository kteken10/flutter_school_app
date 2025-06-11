import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/teacher_service.dart';
import '../../ui/teacher_card.dart';

class AdminTeachersScreen extends StatefulWidget {
  const AdminTeachersScreen({super.key});

  @override
  State<AdminTeachersScreen> createState() => _AdminTeachersScreenState();
}

class _AdminTeachersScreenState extends State<AdminTeachersScreen> {
  late Future<List<UserModel>> _teachersFuture;
  final TeacherService _teacherService = TeacherService();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _teachersFuture = _teacherService.getTeachers();
    });
  }

List<UserModel> _filterTeachers(List<UserModel> teachers, String query) {
  if (query.trim().isEmpty) return teachers;

  final lowerQuery = query.toLowerCase();

  return teachers.where((teacher) {
    final nameMatch = teacher.fullName.toLowerCase().contains(lowerQuery);
    final emailMatch = teacher.email.toLowerCase().contains(lowerQuery);
    final departmentMatch = teacher.department?.toLowerCase().contains(lowerQuery) ?? false;

    return nameMatch || emailMatch || departmentMatch;
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Enseignants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTeachers,
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un enseignant...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadTeachers,
              child: FutureBuilder<List<UserModel>>(
                future: _teachersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Erreur: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadTeachers,
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_outline, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucun enseignant trouvé',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showAddTeacherDialog(context),
                            child: const Text('Ajouter un enseignant'),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredTeachers = _filterTeachers(
                    snapshot.data!,
                    _searchController.text,
                  );

                  return ListView.separated(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  itemCount: filteredTeachers.length,
  separatorBuilder: (context, index) => const SizedBox(height: 12),
  itemBuilder: (context, index) {
    final teacher = filteredTeachers[index];
    return TeacherCard(
      key: ValueKey(teacher.id), 
      name: teacher.fullName,
      
      profileImageUrl: teacher.photoUrl ?? '',
     classes: teacher.classesDisplay,
     
      email: teacher.email,
      classCount: teacher.assignedClassIds.length,
      subjectCount: teacher.taughtSubjectIds.length,
      subjects: teacher.subjectsDisplay,
      onAddPressed: () => _handleAddAction(teacher),
     
    );
  },
);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTeacherDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleAddAction(UserModel teacher) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Ajouter une matière'),
              onTap: () {
                Navigator.pop(context);
                _showAddSubjectDialog(teacher);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Ajouter une classe'),
              onTap: () {
                Navigator.pop(context);
                _showAddClassDialog(teacher);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubjectDialog(UserModel teacher) {
    // Implémentation à compléter
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une matière'),
        content: const Text('Fonctionnalité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showAddClassDialog(UserModel teacher) {
    // Implémentation à compléter
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une classe'),
        content: const Text('Fonctionnalité à implémenter'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showTeacherDetails(UserModel teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(teacher.fullName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.email, teacher.email),
              _buildDetailRow(Icons.work, teacher.departmentDisplay),
              _buildDetailRow(Icons.calendar_today, 
                  '${teacher.yearsOfExperience} ans d\'expérience'),
              _buildDetailRow(Icons.verified_user, 
                  teacher.isActive ? 'Actif' : 'Inactif'),
              
              const SizedBox(height: 16),
              _buildSectionTitle('Matières enseignées (${teacher.subjectsDisplay.length})'),
              ...teacher.subjectsDisplay.map((s) => _buildListItem(s)),
              
              const SizedBox(height: 16),
              _buildSectionTitle('Classes assignées (${teacher.classesDisplay.length})'),
              ...teacher.classesDisplay.map((c) => _buildListItem(c)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showAddTeacherDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _departmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un enseignant'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ obligatoire' : null,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ obligatoire' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ obligatoire' : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _departmentController,
                  decoration: const InputDecoration(labelText: 'Département'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // TODO: Implémenter la sauvegarde
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enseignant ajouté avec succès')),
                );
                _loadTeachers();
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}