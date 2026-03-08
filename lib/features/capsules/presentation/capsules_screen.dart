import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/capsules_provider.dart';
import 'widgets/capsule_card.dart';

class CapsulesScreen extends ConsumerWidget {
  const CapsulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capsulesAsync = ref.watch(capsulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои капсулы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: capsulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 12),
              Text(
                'Ошибка загрузки',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.refresh(capsulesProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
        data: (capsules) {
          if (capsules.isEmpty) {
            return const Center(
              child: Text(
                'Пока нет капсул.\nСоздай первую!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(capsulesProvider.future),
            child: ListView.builder(
              itemCount: capsules.length,
              itemBuilder: (context, index) {
                final capsule = capsules[index];
                return CapsuleCard(
                  message: capsule.message,
                  openDate: capsule.openAt,
                  isOpened: capsule.isOpened,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
