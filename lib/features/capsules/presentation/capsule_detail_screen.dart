import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/capsule.dart';
import '../../../core/theme/app_theme.dart';

class CapsuleDetailScreen extends StatelessWidget {
  final Capsule capsule;

  const CapsuleDetailScreen({super.key, required this.capsule});

  @override
  Widget build(BuildContext context) {
    final isOpened = capsule.isOpened;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final openDay = DateTime(capsule.openAt.year, capsule.openAt.month, capsule.openAt.day);
    final daysLeft = openDay.difference(today).inDays;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(isOpened ? 'Капсула открыта' : 'Капсула запечатана'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: isOpened ? _OpenedBody(capsule: capsule) : _SealedBody(daysLeft: daysLeft, capsule: capsule),
      ),
    );
  }
}

class _SealedBody extends StatelessWidget {
  final int daysLeft;
  final Capsule capsule;

  const _SealedBody({required this.daysLeft, required this.capsule});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.card,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.3), width: 2),
          ),
          child: const Icon(Icons.lock, color: AppTheme.textSecondary, size: 44),
        ),
        const SizedBox(height: 24),
        Text(
          'Откроется через',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Text(
          '$daysLeft ${_daysWord(daysLeft)}',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${capsule.openAt.day}.${capsule.openAt.month}.${capsule.openAt.year}',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Сообщение скрыто',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 200,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 140,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _daysWord(int days) {
    if (days % 100 >= 11 && days % 100 <= 19) return 'дней';
    switch (days % 10) {
      case 1: return 'день';
      case 2:
      case 3:
      case 4: return 'дня';
      default: return 'дней';
    }
  }
}

class _OpenedBody extends StatelessWidget {
  final Capsule capsule;

  const _OpenedBody({required this.capsule});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5), width: 2),
          ),
          child: const Icon(Icons.lock_open, color: AppTheme.primary, size: 44),
        ),
        const SizedBox(height: 24),
        Text(
          'Открыта ${capsule.openAt.day}.${capsule.openAt.month}.${capsule.openAt.year}',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
          ),
          child: Text(
            capsule.message,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 17,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
