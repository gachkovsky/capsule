import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CapsuleCard extends StatelessWidget {
  final String message;
  final DateTime openDate;
  final bool isOpened;

  const CapsuleCard({
    super.key,
    required this.message,
    required this.openDate,
    required this.isOpened,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = openDate.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOpened
              ? AppTheme.primary.withOpacity(0.5)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                isOpened ? Icons.lock_open : Icons.lock,
                color: isOpened ? AppTheme.primary : AppTheme.textSecondary,
                size: 20,
              ),
              Text(
                isOpened
                    ? 'Открыта'
                    : daysLeft > 0
                        ? 'Через $daysLeft дн.'
                        : 'Готова к открытию',
                style: TextStyle(
                  color: isOpened ? AppTheme.primary : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${openDate.day}.${openDate.month}.${openDate.year}',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}