import 'package:flutter/material.dart';
import '../constants/colors.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime dateTime;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isRead;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.dateTime,
    this.icon,
    this.onTap,
    this.onDelete,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    if (onDelete == null) {
      return _buildCardContent(context);
    }

    return Dismissible(
      key: Key(title + dateTime.toString()),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(),
      secondaryBackground: _buildSwipeBackground(),
      confirmDismiss: (direction) async => true,
      onDismissed: (direction) => onDelete?.call(),
      child: _buildCardContent(context),
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white, size: 24),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isToday(dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: isRead ? Colors.white : Colors.blue.shade50.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Réduit la hauteur intrinsèque
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icône
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon ?? Icons.notifications_none,
                      color: AppColors.secondary,
                      size: 20, // Icône légèrement plus petite
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Contenu texte
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre et indicateur non lu
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isRead
                                      ? AppColors.textPrimary
                                      : AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(left: 6),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Description
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2, // Réduit à 2 lignes maximum
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Bouton suppression (optionnel)
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                        size: 18, // Bouton plus petit
                      ),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              // Date/heure alignée à droite
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isToday
                        ? 'à ${_formatTime(dateTime)}'
                        : _formatDateTime(dateTime),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inDays == 1) return 'Hier à ${_formatTime(dt)}';
    if (difference.inDays < 7) return '${_getWeekday(dt.weekday)} à ${_formatTime(dt)}';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return weekdays[weekday - 1];
  }
}