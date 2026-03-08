import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/capsules_repository.dart';
import '../../domain/capsule.dart';

final capsulesRepositoryProvider = Provider<CapsulesRepository>((ref) {
  return CapsulesRepository(Supabase.instance.client);
});

final capsulesProvider = FutureProvider<List<Capsule>>((ref) {
  return ref.watch(capsulesRepositoryProvider).fetchCapsules();
});
