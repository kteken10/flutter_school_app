import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? imageAsset;
  final String? fullName;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.imageAsset,
    this.fullName,
    this.radius = 24,
  }) : assert(
          imageUrl == null || imageAsset == null,
          'Ne fournissez qu\'une seule source d\'image (URL ou asset)',
        );

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageAsset != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(imageAsset!),
        backgroundColor: Colors.grey.shade300,
        onBackgroundImageError: (_, __) => _placeholder(),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: Colors.grey.shade300,
        onBackgroundImageError: (_, __) => _placeholder(),
      );
    } else if (fullName != null && fullName!.isNotEmpty) {
      final initials = _getInitials(fullName!);
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: radius * 0.8,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return _placeholder();
    }
  }

  Widget _placeholder() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      child: Icon(
        Icons.person,
        size: radius,
        color: Colors.grey.shade600,
      ),
    );
  }
}
