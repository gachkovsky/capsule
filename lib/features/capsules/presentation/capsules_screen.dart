import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/capsule_card.dart';

class CapsulesScreen extends ConsumerWidget {
  const CapsulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Тестовые данные пока нет Supabase
    final capsules = [
      {
        'message': 'Привет себе через год! Надеюсь ты достиг всего что хотел.',
        'openDate': DateTime.now().add(const Duration(days: 365)),
        'isOpened': false,
      },
      {
        'message': 'Помни зачем ты начал. Ты справишься.',
        'openDate': DateTime.now().add(const Duration(days: 30)),
        'isOpened': false,
      },
      {
        'message': 'Это была лучшая поездка в моей жизни.',
        'openDate': DateTime.now().subtract(const Duration(days: 5)),
        'isOpened': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои капсулы'),
      ),
      body: ListView.builder(
        itemCount: capsules.length,
        itemBuilder: (context, index) {
          final capsule = capsules[index];
          return CapsuleCard(
            message: capsule['message'] as String,
            openDate: capsule['openDate'] as DateTime,
            isOpened: capsule['isOpened'] as bool,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}